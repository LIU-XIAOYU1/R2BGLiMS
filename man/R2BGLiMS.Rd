% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/R2BGLiMS.R
\name{R2BGLiMS}
\alias{R2BGLiMS}
\title{Call BGLiMS from R}
\usage{
R2BGLiMS(likelihood = NULL, data = NULL, outcome.var = NULL,
  times.var = NULL, subcohort.var = NULL, confounders = NULL,
  model.selection = TRUE, model.space.priors = NULL, beta.priors = NULL,
  beta.prior.partitions = NULL, dirichlet.alphas.for.roc.model = 0.01,
  g.prior = TRUE, tau = NULL, enumerate.up.to.dim = 0, X.ref = NULL,
  yTy.ref = NULL, n.for.jam = NULL, marginal.betas = NULL,
  subcohort.sampling.fraction = NULL, casecohort.pseudo.weight = 1,
  n = NULL, max.fpr = 1, min.tpr = 0, n.iter = 1e+06,
  n.mil.iter = NULL, thinning.interval = NULL, seed = 1,
  extra.arguments = NULL, initial.model = NULL, max.model.dim = -1,
  results.label = NULL, save.path = NULL, extra.java.arguments = NULL)
}
\arguments{
\item{likelihood}{Type of model to fit. Current options are 
"Logistic" (for binary data), 
"CLogLog" complementary log-log link for binary data, 
"Weibull" (for survival data), 
"Cox" (for survival data), 
"CaseCohort_Prentice" (for case-cohort survival data with Prentice weighting), 
"CaseCohort_Barlow" (for case-cohort survival data with Barlow weighting), 
"RocAUC" (to optimise ROC AUC),
"RocAUC_Anchoring" (to optimise ROC AUC using the anchoring formulation),
"Gaussian" (for linear regression), 
"GaussianConj" (linear regression exploiting conjugate results), 
"JAM" (for conjugate linear regression using summary statistics, integrating out parameters) 
and "JAM_MCMC" (for linear regression using summary statistics, with full MCMC of all parameters).}

\item{data}{Matrix or dataframe containing the data to analyse. 
Rows are indiviuals, and columns contain the variables and outcome.
If modelling summary statistics specify X.ref, marginal.betas, and n instead (see below).}

\item{outcome.var}{Name of outcome variable in data. For survival data see times.var below.
If modelling summary statistics with JAM this can be left null but you must specify X.ref, marginal.beats and n instead (see below).}

\item{times.var}{SURVIVAL DATA ONLY Name of column in data which contains the event times.}

\item{subcohort.var}{CASE-COHORT DATA ONLY Name of column in data which contains a binary indicator of membership in the
propsectviely sampled (and population representative) sub-cohort.}

\item{confounders}{Optional vector of confounders to fix in the model at all times, i.e. exclude from model selection.}

\item{model.selection}{Whether to use model selection (default is TRUE). NB: Even if set to FALSE, please provide a 
dummy model.space.priors argument (see below). This will not be used mathematically, but the package requires taking the list of variable
names from the "Variables" element therein.}

\item{model.space.priors}{Must be specified if model.selection is set to TRUE.
Two options are available. 1) A fixed prior is placed on the proportion of causal 
covariates, and all models with the same number of covariates is equally likely. This
is effectively a Poisson prior over the different possible model sizes. A list must
be supplied for `model.space.priors` with an element "Rate", specifying the prior 
proportion of causal covariates, and an element "Variables" containing the list of covariates
included in the model search. 2) The prior proportion of causal covariates
is treated as unknown and given a Beta(a, b) hyper-prior, in which case 
elements "a" and "b" must be included in the `model.space.priors` list rather
than "Rate". Higher values of "b" relative to "a" will encourage sparsity.
NOTE: It is easy to specify different model space priors for different collections of
covariates by providing a list of lists, each element of which is itself a model.space.prior
list asm described above for a particular subset of the covariates.}

\item{beta.priors}{There are three options: 
1) Leave as null, in which case N(0, 1e6) priors are placed on the effects
of confounders and any predictors included in model selection are assigned a
common normal prior with unknown variance.
2) Provide fixed priors for the confounders only. 
3) Provide fixed priors for all covariates. 
beta.priors (a matrix/data.frame) can be used to provide fixed priors; rows must be named with the corresponding 
variable names in the data, and include Guassian prior means and sds in the first and 
second columns respectively.}

\item{beta.prior.partitions}{By default, covariates without informative priors are 
ascribed a common Gaussian prior with a Unif(0.01,2) hyper-prior on the effect 
standard deviation. beta.prior.partitions can be used to partition the covariates 
into different prior groups, within each of which exchangeability can be assumed 
and a common prior with an independently estimated variance is used. 
beta.prior.partitions must be a list with as many elements as desired 
partitions. Each element must in turn be a list containing the following named 
elements: "Variables" - a list of covariates to be included in this partition, 
and "UniformA" and "UniformB" the Uniform hyper parameters. I.e., for a particular
partition, for v in "Variables", 
beta[v] | sigma_beta ~ N(0, sigma_beta^2) and 
sigma_beta ~ Unif("UniformA", "UniformB").}

\item{dirichlet.alphas.for.roc.model}{This can either be a single number, if you wish the same concentration parameter 
to be used for every covariate. Alternatively a vector can be supplied, with an element corresponding to every variable.}

\item{g.prior}{Whether to use a g-prior for the beta's, i.e. a multivariate normal 
with correlation structure proportional to sigma^2*X'X^-1, which is thought to aid
variable selection in the presence of strong correlation. By default this is enabled.}

\item{tau}{Value to use for sparsity parameter tau (under the tau*sigma^2 parameterisation).
When using the g-prior, a recommended default is max(n, P^2) where n is the number of individuals, and P is the number of predictors.}

\item{enumerate.up.to.dim}{Whether to make posterior inference by exhaustively calculating
the posterior support for every possible model up to this dimension. Leaving at 0 to disable
and use RJMCMC instead. The current maximum allowed value is 5.}

\item{X.ref}{Reference genotype matrix used by JAM to impute the SNP-SNP correlations. If multiple regions are to be 
analysed this should be a list containing reference genotype matrices for each region. Individual's genotype
must be coded as a numeric risk allele count 0/1/2. Non-integer values reflecting imputation may be given.
NB: The risk allele coding MUST correspond to that used in marginal.betas. These matrices must each be positive definite and
the column names must correspond to the names of the marginal.betas vector.}

\item{yTy.ref}{Estimate of the trait variance * N; for use with JAMv2 (Daniel Ahfock's extension).}

\item{n.for.jam}{For JAMv2 (Daniel Ahfock's extension), the N of the data must be provided.}

\item{marginal.betas}{Vector of marginal effect estimates to re-analyse with JAM under multivariate models.}

\item{max.fpr}{ROC AUC ONLY: Maximum acceptable false positive rate (or x-axis value) to optimise a truncated ROC AUC.}

\item{min.tpr}{ROC AUC ONLY: Minimum acceptable true positive rate, i.e. sensitivity (or y-axis value) to optimise a truncated ROC AUC.}

\item{n.iter}{Number of iterations to run (default is 1e6)}

\item{n.mil.iter}{Number of million iterations to run. Can optionally be used instead of n.iter for convenience, which it will overide if specified.}

\item{thinning.interval}{Every nth iteration to store (i.e. for the Java algorithm to write to a file and then read into R). By default this is the
number of iterations divided by 1e4 (so for 1 million iterations every 100th is stored.) Higher values (so smaller posterior sample) can lead to 
faster runtimes for large numbers of covariates.}

\item{seed}{Which random number seed to use in the RJMCMC sampler.}

\item{extra.arguments}{A named list of any additional arguments for BGLiMS. Type "data(DefaultArguments)" and look in the 
"default.arguments" list to see the names (which must match) and default values of available extra arguments. Currently these 
are not documented - please contact the package author, Paul Newcombe for details.}

\item{initial.model}{Optionally, an initial model can be provided as a vector of 0's and 1's. Default is NULL
and the null model is used. If set to 1, the saturated model is used.}

\item{max.model.dim}{Optional specification of maximum model dimension (default -1 means no maximum is set).}

\item{results.label}{Optional label for algorithm output files (if you have specified save.path).}

\item{save.path}{Optional path to save BGLiMS's data and results files. These are usually written as temporary files, and deleted
after running R2BGLiMS. However, this option might help for debugging.}

\item{extra.java.arguments}{A character string to be passed through to the java command line. E.g. to specify a
different temporary directory by passing "-Djava.io.tmpdir=/Temp".}

\item{n:}{Sample size which marginal.betas were calculated in.}

\item{subcohort.sampling.fraction:}{CaseCohort_Barlow ONLY: The sampling fraction of the sub-cohort from the full cohort, in order
to calculate weights for use with the Barlow Case-Cohort pseudo-likelihood (Barlow 1994) REF}

\item{casecohort.pseudo.weight:}{CaseCohort ONLY: Multiplier for the pseudo log-likelihood relative to
the prior.}
}
\value{
A R2BGLiMS_Results class object is returned. See the slot 'posterior.summary.table' for a posterior
summary of all parameters.

The function \code{\link{PrettyResultsTable}} can be used to print summary posterior results for all parameters. Other functions
for summarising results are listed under "see also".
}
\description{
Calls BGLiMS - a Java package for fitting GLMs under Bayesian model selection. NOTE: The predictors to explore with model
selection are specified via the model.space.priors argument - see examples. By Default a common, and unknown, prior SD
is used for all predictors under model selection, which in turn is assigned an Inverse-Gamma hyper-prior.
Fixed normal priors may be user specified for all predictor (and confounder) coefficients via the beta.priors argument.
}
\examples{
library(R2BGLiMS)

# NB: See ?JAM for JAM examples.
#
# Examples below are:
# 1) Logistic regression
# 2) Weibull regression survival analysis
# 3) Case-cohort logistic regression (with hazard ratio estimation using Prenctice weighted Cox regression)
# 4) Linear regression
# 5) Linear regression using a conjugate posterior (with coefficients analytically intergreated out)
# 6) Fixed priors on effects, rather than the default common prior with unknown variance
# 7) Using two model space partitions

##########################################
# --- Example 1) Logistic regression --- #
##########################################

utils::data(biopsy, package = "MASS") # Example logistic dataset
covariate.names <- paste0("V",c(1:9))
# Recommend standardising predictors to justify default common hierarchical prior on effects
for (v in covariate.names) {biopsy[,v] <- scale(biopsy[,v])} 
biopsy$class <- as.integer(biopsy$class) - 1
biopsyResults <- R2BGLiMS( # Takes a few minutes to run
  likelihood="Logistic",
  data=biopsy,
  outcome.var="class",
  model.space.priors=list("a"=1, "b"=length(covariate.names), "Variables"=covariate.names), # Beta-binomial(1,P) model space prior
  extra.arguments=list("AlphaPriorMu"=log(mean(biopsy$class)/(1-mean(biopsy$class)))) # Recommend centering intercept prior on logit(event rate)
)
# Simple convergence diagnostic
plot(biopsyResults@mcmc.output[,"LogLikelihood"], type="l") # Looks ok
# Summary plot of selection probabilities
ManhattanPlot(biopsyResults) # Evidence of several independent effects
# Summary table
biopsyResults@posterior.summary.table
TopModels(biopsyResults)

###########################################################
# --- Example 2) Weibull regression survival analysis --- #
###########################################################

utils::data(VA, package = "MASS")
predictors <- c("treat","age","Karn","diag.time","prior")
for (v in predictors) {VA[,v] <- scale(as.numeric(VA[,v]))} # Normalise predictors
VA$stime <- VA$stime/max(VA$stime)# Recommend scaling survival times to between 0 and 1
va.results.weibull <- R2BGLiMS(
  likelihood="Weibull",
  data=VA,
  outcome.var="status",
  times.var="stime",
  model.space.priors=list(list("a"=1,"b"=length(predictors),"Variables"=predictors)) # Beta-binomial(1,P) model space prior
)
plot(va.results.weibull@mcmc.output[,"LogLikelihood"], type="l") # Looks ok
ManhattanPlot(va.results.weibull) # Clear signal at Kern
va.results.weibull@posterior.summary.table
TopModels(va.results.weibull)

######################################################
# --- Example 3) Case-cohort logistic regression --- #
######################################################

# --- Step 1: Logistic RJMCMC
data("CaseCohortExample") # Only V1,V2,V3,V4,V5 have true effects.
for (v in covariate.names) { data.cc[,v] <- data.cc[,v] - mean(data.cc[,v]) }
logistic.cc.res <- R2BGLiMS(
  likelihood="Logistic",
  data=data.cc,
  outcome.var="event",
  model.space.priors=list(list("a"=1,"b"=length(covariate.names),"Variables"=covariate.names)),
  n.mil=0.2,
  extra.arguments=list("AlphaPriorMu"=log(mean(data.cc$event)/(1-mean(data.cc$event))))
)
plot(logistic.cc.res@mcmc.output[,"LogLikelihood"], type="l") # Looks ok
ManhattanPlot(logistic.cc.res) # Identifies 4 out of 5 true effects
logistic.cc.res@posterior.summary.table

# --- Step 2: Effect estimation using the Prentice model
library(survival)
top.vars <- names(which(logistic.cc.res@posterior.summary.table[covariate.names,"BF"]>5))
prentice.model.formula <- as.formula(paste("Surv(times, event) ~ ",paste(top.vars, collapse="+")))
prentice.res <- cch(
  prentice.model.formula,
  data = data.cc,
  subcoh = ~subcohort,
  id=~ID,
  cohort.size=n.complete.cohort, 
  method="Prentice")
summary(prentice.res)

#######################################################
# --- Example 4) Linear regression with full MCMC --- #
#######################################################

data("LinearModelExample") # True effect at V1 only
lm.results <- R2BGLiMS(
  likelihood="Gaussian", 
  data=data.cts.outcome, 
  outcome.var="y", 
  confounders="confounder", # Example of a variable to include always
  model.space.priors = list("a"=1, "b"=length(covariate.names), "Variables"=covariate.names) # Beta-binomial(1,P) prior on model space
)
plot(lm.results@mcmc.output[,"LogLikelihood"], type="l") # Looks ok
ManhattanPlot(lm.results)
lm.results@posterior.summary.table

#############################################################################
# --- Example 5) Linear regression using a conjugate marginal posterior --- #
#############################################################################

# Coefficients are analytically integrated out
# Only models are sampled so mixing should be better
data("LinearModelExample") # True effect at V1 only
lm.conjugate.results <- R2BGLiMS(
  likelihood="GaussianConj", 
  data=data.cts.outcome, 
  outcome.var="y",
  confounders="confounder", # Example of a variable to include always
  tau=max(nrow(data.cts.outcome),ncol(data.cts.outcome)^2), # Tau recommended to be maximum of P^2 and N
  model.space.priors = list("a"=1, "b"=length(covariate.names), "Variables"=covariate.names), # Beta-binomial(1,P)prior on model space
  g.prior=T)
# Summary plot of selection probabilities
ManhattanPlot(lm.conjugate.results) # More decisive than above
TopModels(lm.conjugate.results)
# Posterior sample of parameter in top model
posterior.sample <- NormInvGamPosteriorSample(
  data=data.cts.outcome, outcome.var ="y", confounders="confounder",
  model=c("V1"),tau=100)
# Median and credible interval
round(quantile(posterior.sample[,"V1"],c(0.5, 0.025, 0.975)),2) # Clearly excludes 0

##############################################
# --- Example 6) Fixed priors on effects --- #
##############################################

# By default, a common prior with unkown variance is assumed for all effects
# Might want to explicitly specify these priors instead the priors (e.g. if there is prior information)
data("LinearModelExample") # True effect at V1 only
lm.results.fixed.priors <- R2BGLiMS(
  likelihood="Gaussian", 
  data=data.cts.outcome, 
  outcome.var="y", 
  confounders="confounder", # Example of a variable to include always
  beta.priors = data.frame(
    cbind(
      rep(0,11), # Normal pior means
      rep(1,11)), # Normal prior SDs
    row.names=c("confounder",covariate.names)),
  model.space.priors = list("a"=1, "b"=length(covariate.names), "Variables"=covariate.names) # Beta-binomial(1,P) prior on model space
)
plot(lm.results.fixed.priors@mcmc.output[,"LogLikelihood"], type="l") # Looks ok
ManhattanPlot(lm.results.fixed.priors)
lm.results.fixed.priors@posterior.summary.table

#################################################
# --- Example 7) Two model space partitions --- #
#################################################

# Can provide different levels of prior sparsity to different groups of covariates
# Demonstrated below with two groups
data("LinearModelExample") # True effect at V1 only
lm.results.two.model.space.partitions <- R2BGLiMS(
  likelihood="Gaussian", 
  data=data.cts.outcome, 
  outcome.var="y", 
  confounders="confounder", # Example of a variable to include always
  model.space.priors = list(
    list("a"=1, "b"=1, "Variables"=covariate.names[1:5]), # Generous 50/50 prior proportion
    list("a"=1, "b"=1000, "Variables"=covariate.names[6:10]) # Very sparse!
    )
)
plot(lm.results.two.model.space.partitions@mcmc.output[,"LogLikelihood"], type="l") # Looks ok
ManhattanPlot(lm.results.two.model.space.partitions)
lm.results.two.model.space.partitions@posterior.summary.table
}
\seealso{
For a nicer summary of all covariates see 
\code{\link{PrettyResultsTable}} and \code{\link{ManhattanPlot}}. For posterior model space
summaries see \code{\link{TopModels}}. For convergence checks
plots see \code{\link{ChainPlots}} and \code{\link{AutocorrelationPlot}}.
}
\author{
Paul Newcombe
}
