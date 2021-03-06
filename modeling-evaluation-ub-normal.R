library(lattice)
library(DAAG)
library(broom)
setwd("~/exports")

set.seed(123)
par(mfrow = c(1, 1))

train.ub.normal.index <-
  sample(1:nrow(filtered.ubunutu.normal),
         0.8 * nrow(filtered.ubunutu.normal))
train.ub.nr <- filtered.ubunutu.normal[train.ub.normal.index,]
test.ub.nr <- filtered.ubunutu.normal[-train.ub.normal.index,]

md.ub.nr <-
  lm(
    real.power ~ battery.rate  + I(battery.rate ^ 2) + charging.status +   battery.rate:battery.capacity  +
      cpu.usage + memory.usage  + battery.capacity + download.upload + read.write,
    data = train.ub.nr
  )

tidy.md.ub.nr <- tidy(md.ub.nr)
write.csv(tidy.md.ub.nr, "_ubuntu_normal_coef.csv")

summary(md.ub.nr)

coefficients(md.ub.nr)
mean(residuals(md.ub.nr))

AIC(md.ub.nr)
BIC(md.ub.nr)
pred.ub.nr = predict(md.ub.nr, test.ub.nr)

actual.pred.ub.nr <-
  data.frame(cbind(actuals = test.ub.nr$real_power, predicteds = pred.ub.nr))
correlation.accuracy.ub.nr <- cor(actual.pred.ub.nr)

min.max.accuracy.ub.nr <-
  mean(apply(actual.pred.ub.nr, 1, min) / apply(actual.pred.ub.nr, 1, max)) * 100
mape.ub.nr <-
  mean(abs(actual.pred.ub.nr$predicteds - actual.pred.ub.nr$actuals) / actual.pred.ub.nr$actuals) * 100

#boxplot(filtered.ubunutu.normal$real_power, main="realpower", sub=paste("Outlier rows: ", boxplot.stats(filtered.ubunutu.normal$real_power)$out))

