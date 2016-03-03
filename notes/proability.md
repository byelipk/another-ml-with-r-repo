A probability is a number between 0 and 1 which captures
the chance that an event will occur given the available
evidence. The lower the probability, the less likely the
event will occur. The higher the probability, the more
likely it will.

Bayesian probability theory is rooted in the idea that
the estimated likelihood of an event, or potential outcome,
should be based on the evidence at hand across multiple
trials, or opportunities for that event to occur.

For example, in order for us to predict that a message
is spam (event), we will gather our evidence across
multiple incoming messages. Each message is an instance
of a trial.

The probability of an event is estimated by dividing the
total number of trials in which the event occurred by
the total number of trials.

If we received 10 messages and 2 were spam, then the
probability of receiving a spam message is 2/10 or 0.20.

```
P(spam)  = 0.20
P(!spam) = 0.80
```

### Conditional Probability

Let's say 20% of all messages were spam and 5% of those
messages contained the word 'viagra'.

How do we calculate the probability that both P(spam)
and P(viagra) occur?

```
P(spam && viagra)
```

Well, if P(spam) and P(viagra) were independent events,
if they were totally unrelated, then we could calculate
the probability by multiply the probabilities together:

```
P(spam && viagra) = P(spam) * P(viagra)

0.01 = 0.20 * 0.05
```

However we know that P(spam) and P(viagra) are likely to
be highly dependent. That means our above calculation
is incorrect. To obtain a reasonable estimate we need
to use more advanced methods based on Bayes' Theorem.

```
P(A|B) = P(A && B) / P(B)
```

This notation is read as follows:

**The probability of event A, given that event B has already occurred.** This is conditional probability since the probability of event A is dependent on what happened with event B. Bayes' Theorem tells us that our estimate of P(A|B) should be based on how often events A and B occur together and how often event B occurs in general.

Another way of saying this is that if we know event B occurred, the probability of event A occurring is higher the more often that A and B occur together each time B is observed.


###### Prior Probability
The probability that any prior message was identified as spam.

###### Likelihood
The probability that the word viagra was used in spam messages.

###### Marginal Likelihood
The probability that the word viagra appeared in any messages at all.

###### Posterior Probability
A measure of how likely a message is to be spam.

```
Bayes' Theorem

(posterior probability) =
  (likelihood) * (prior probability) /
    (marginal likelihood)
```

Let's construct a frequency table to see how many times the word viagra occurred in messages:

```
====== viagra ===
spam  4  16  20
ham   1  79  80
```

Now we can construct a likelihood table:

```
======= viagra ======
spam  4/20  16/20  20
ham   1/80  79/80  80
```

This table tells us that given a message is identified as spam, there is a 20% probability that the message contains the word viagra.

```
We compute the joint probability, which is composed
of the likelihood and the prior probability:

P(spam|viagra) =
  P(viagra|spam) * P(spam) =
    (4/20) * (20/100) = 0.04


And now for the posterior probability:

P(spam|viagra) =
  P(viagra|spam) * P(spam) / P(viagra) =
    (4/20) * (20/100) / (5/100) = 0.80
```
