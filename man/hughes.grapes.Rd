\name{hughes.grapes}
\alias{hughes.grapes}
\docType{data}
\title{
  Disease incidence on grape leaves in RCB experiment
}
\description{
  Disease incidence on grape leaves in RCB experiment with 6 different
  treatments.
}

\format{
  A data frame with 270 observations on the following 6 variables.
  \describe{
    \item{\code{block}}{Block factor, 1-3}
    \item{\code{trt}}{Treatment factor, 1-6}
    \item{\code{vine}}{Vine factor, 1-3}
    \item{\code{shoot}}{Shoot factor, 1-5}
    \item{\code{diseased}}{Number of diseased leaves per shoot}
    \item{\code{total}}{Number of total leaves per shoot}
  }
}
\details{
  
  These data come from a study of downy mildew on grapes.  The
  experiment was conducted at Wooster, Ohio, on the experimental farm of
  the Ohio Agricultural Research and Development Center, Ohio State
  University.

  There were 3 blocks with 6 treatments.  Treatment 1 is
  the unsprayed control.  On 30 Sep 1990, disease incidence was
  measured.  For each plot, 5 randomly chosen shoots on each of the 3
  vines were observed.  The canopy was closed and shoots could be
  intertwined.  On each shoot, the total number of leaves and the number
  of infected leaves were recorded.
  
}

\source{
  Hughes, G. and Madden, LV. 1995.
  Some methods allowing for aggregated patterns of disease incidence in
  the analysis of data from designed experiments.
  \emph{Plant Pathology}, 44, 927--943.
  http://doi.org/10.1111/j.1365-3059.1995.tb02651.x

  Used with permission of Larry Madden.
}

\references{
  Hans-Pieter Piepho. 1999.
  Analysing disease incidence data from designed experiments by
  generalized linear mixed models.
  \emph{Plant Pathology}, 48, 668--684.
  http://doi.org/10.1046/j.1365-3059.1999.00383.x
}

\examples{

data(hughes.grapes)
dat <- hughes.grapes

dat <- transform(dat, rate = diseased/total, plot=trt:block)

# Trt 1 has higher rate, more variable, Trt 3 lower rate, less variable
require(lattice)
foo <- bwplot(rate ~ vine|block*trt, dat, main="hughes.grapes",
              xlab="vine")
if(require(latticeExtra)){
  useOuterStrips(foo)
}

# Table 1 of Piepho 1999
tapply(dat$rate, dat$trt, mean) # trt 1 does not match Piepho
tapply(dat$rate, dat$trt, max)

# ----------------------------------------------------------------------------

\dontrun{
  # Piepho model 3.  Binomial data.  May not be exactly the same model
  
  # Use the binomial count data with lme4
  require(lme4)
  m1 <- glmer(cbind(diseased, total-diseased) ~ trt + block + (1|plot/vine),
              data=dat, family=binomial)
  m1

  # Switch from binomial counts to bernoulli data
  require(aod)
  bdat <- splitbin(cbind(diseased, total-diseased) ~ block+trt+plot+vine+shoot,
                   data=dat)$tab
  names(bdat)[2] <- 'y'
  
  # Using lme4
  m2 <- glmer(y ~ trt + block + (1|plot/vine), data=bdat, family=binomial)
  m2
  
  # Now using MASS:::glmmPQL
  require(MASS)
  m3 <- glmmPQL(y ~ trt + block, data=bdat,
                random=~1|plot/vine, family=binomial)
  m3
}

}

