sms_raw <- read.csv("../book/Chapter04/sms_spam.csv", stringsAsFactors=FALSE)

# Let's see what we got here...
str(sms_raw)

# sms_raw$type should be a factor
sms_raw$type <- as.factor(sms_raw$type)

# Now we can inspect the frequencies
table(sms_raw$type)

# That's enough for basic preparation of our data.
# But in order to build a classifier, we need to
# run some more advanced processing on the text data
# that we get when we load the `tm` package.
library(tm)

# STEP 1: Build a corpus
sms_corpus <- VCorpus(VectorSource(sms_raw$text))

print(sms_corpus)
inspect(sms_corpus[1:2])
lapply(sms_corpus[1:2], as.character)

# STEP 2: Sanitize the text
?tm_map

# Normalize text by converting it all to lowercase
sms_corpus_clean <- tm_map(
  sms_corpus,
  content_transformer(tolower))

# Strip all numbers from text as most
# are not likely to be helpful
sms_corpus_clean <- tm_map(
  sms_corpus_clean,
  removeNumbers)

# Remove stop words
sms_corpus_clean <- tm_map(
  sms_corpus_clean,
  removeWords,
  stopwords())

# Remove punctuation
sms_corpus_clean <- tm_map(
  sms_corpus_clean,
  removePunctuation
)

# Perform stemming on the words
library(SnowballC)

sms_corpus_clean <- tm_map(sms_corpus_clean, stemDocument)

# Strip white space
sms_corpus_clean <- tm_map(sms_corpus_clean, stripWhitespace)


# STEP 3: Split text documents into words
sms_dtm <- DocumentTermMatrix(sms_corpus_clean)

# STEP 4: Create training and test datasets
sms_dtm_train <- sms_dtm[1:4169,]
sms_dtm_test  <- sms_dtm[4170:5559,]

sms_train_labels <- sms_raw[1:4169,]$type
sms_test_labels  <- sms_raw[4170:5559,]$type

# Confirm that the subsets are representative
# of the raw sms data by comparing the proportion
# of spam messages in the training and test datasets:
prop.table(table(sms_train_labels))
prop.table(table(sms_test_labels))


# We can visually depict the frequency of words
# by using a wordcloud
library(wordcloud)
wordcloud(sms_corpus_clean, min.freq = 50, random.order = FALSE)

spam <- subset(sms_raw, type == "spam")
ham <- subset(sms_raw, type == "ham")

wordcloud(spam$text, min.freq=40, random.order=FALSE)

# We're only including 40 words and scaling each down so 
# they all fit on the screen
wordcloud(ham$text, max.words=40, random.order=FALSE, scale=c(3,0.5))


# STEP 5: Create indicator features for frequent words
sms_freq_words <- findFreqTerms(sms_dtm_train,5)

sms_dtm_freq_train <- sms_dtm_train[, sms_freq_words]
sms_dtm_freq_test  <- sms_dtm_test[, sms_freq_words]

# The Naive Bayes classifier is trained on categorical data.
# This poses a problem to us becaue all of our data is numeric.
# We need to convert our data to a categorical variable that 
# indicates yes or no depending on whether the word appears at all.
convert_counts <- function(x) {
  x <- ifelse(x > 0, "Yes", "No")
}

sms_train <- apply(sms_dtm_freq_train, MARGIN=2, convert_counts)
sms_test  <- apply(sms_dtm_freq_test, MARGIN=2, convert_counts)

# TRAINING THE MODEL
library(e1071)

sms_classifier <- naiveBayes(sms_train, sms_train_labels)


# EVALUATE MODEL PERFORMANCE
sms_test_pred  <- predict(sms_classifier, sms_test)

library(gmodels)

CrossTable(
  sms_test_pred, 
  sms_test_labels, 
  prop.chisq=FALSE, 
  prop.t=FALSE, 
  dnn=c("predicted", "actual"))

# IMPROVE MODEL PERFORMANCE
sms_classifier2 <- naiveBayes(sms_train, sms_train_labels, laplace=1)

sms_test_pred2  <- predict(sms_classifier2, sms_test)

CrossTable(
  sms_test_pred2, 
  sms_test_labels, 
  prop.chisq=FALSE, 
  prop.t=FALSE, 
  dnn=c("predicted", "actual"))