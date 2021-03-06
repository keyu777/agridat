\name{durban.splitplot}
\alias{durban.splitplot}
\docType{data}
\title{
  Split-plot barley variety trial with fungicide treatments
}
\description{
  Split-plot barley variety trial with fungicide treatments.
}

\format{
  A data frame with 560 observations on the following 6 variables.
  \describe{
    \item{\code{yield}}{yield, tonnes/ha}
    \item{\code{block}}{block, 4 levels}
    \item{\code{gen}}{genotype, 70 levels}
    \item{\code{fung}}{fungicide, 2 levels}
    \item{\code{row}}{row}
    \item{\code{bed}}{bed (column)}
  }
}
\details{
  Grown in 1995-1996 at the Scottish Crop Research Institute.
  Split-plot design with 4 blocks, 2 whole-plot fungicide treatments,
  and 70 barley varieties or variety mixes.  Total area was 10 rows
  (north/south) by 56 beds (east/west).
}
\source{
  Durban, Maria and Hackett, Christine and McNicol, James and
  Newton, Adrian and Thomas, William and Currie, Iain. 2003.
  The practical use of semiparametric models in field trials,
  \emph{Journal of Agric Biological and Envir Stats}, 8, 48-66.
  http://doi.org/10.1198/1085711031265.

  Retrieved from: ftp://ftp.bioss.sari.ac.uk/pub/maria

  Used with permission of Maria Durban.
}

\examples{

data(durban.splitplot)
dat <- durban.splitplot

if(require(desplot)){
  desplot(yield~bed*row, dat,
          out1=block, out2=fung, num=gen, # aspect unknown
          main="durban.splitplot")
}


# Durban 2003, Figure 2
m20 <- lm(yield~gen*fung, data=dat)
dat$resid <- m20$resid
## require(lattice)
## xyplot(resid~row, dat, type=c('p','smooth'), main="durban.splitplot")
## xyplot(resid~bed, dat, type=c('p','smooth'), main="durban.splitplot")

# Figure 4 doesn't quite match due to different break points
coplot(resid~bed|row, data=dat, number=8, cex=.5,
       panel=function(x,y,...) panel.smooth(x,y,span=.4,...))
title("durban.splitplot")

# ----------------------------------------------------------------------------

\dontrun{
  # Figure 6 - field trend
  # note, Durban used gam package like this
  # m2lo <- gam(yield ~ gen*fung + lo(row, bed, span=.082), data=dat)
  require(mgcv)
  m2lo <- gam(yield ~ gen*fung + s(row, bed,k=45), data=dat)
  new2 <- expand.grid(row=unique(dat$row), bed=unique(dat$bed))
  new2 <- cbind(new2, gen="G01", fung="F1")
  p2lo <- predict(m2lo, newdata=new2)
  wireframe(p2lo~row+bed, new2, aspect=c(1,.5), main="Field trend")
}

# ----------------------------------------------------------------------------

\dontrun{
  # asreml3
  require(asreml)
  # Table 5, variance components.  Table 6, F tests

  dat <- transform(dat, rowf=factor(row), bedf=factor(bed))
  dat <- dat[order(dat$rowf, dat$bedf),]
  m2a2 <- asreml(yield ~ gen*fung, random=~block/fung+units, data=dat,
                 rcov=~ar1v(rowf):ar1(bedf))
  m2a2 <- update(m2a2)

  require(lucid)
  vc(m2a2)
  ##                effect component std.error z.ratio constr
  ##       block!block.var 0.0000001        NA      NA  bound
  ##  block:fung!block.var 0.01207    0.01513      0.8    pos
  ##       units!units.var 0.02463    0.002465    10      pos
  ##            R!variance 1                NA      NA    fix
  ##            R!rowf.cor 0.8836     0.03647     24    uncon
  ##            R!rowf.var 0.1262     0.04432      2.8    pos
  ##            R!bedf.cor 0.9202     0.02847     32    uncon

  anova(m2a2)
}

# ----------------------------------------------------------------------------

\dontrun{
  ## require(asreml4)
  ## # Table 5, variance components.  Table 6, F tests

  ## dat <- transform(dat, rowf=factor(row), bedf=factor(bed))
  ## dat <- dat[order(dat$rowf, dat$bedf),]
  ## m2a2 <- asreml(yield ~ gen*fung, random=~block/fung+units, data=dat,
  ##                resid =~ar1v(rowf):ar1(bedf))
  ## m2a2 <- update(m2a2)

  ## require(lucid)
  ## vc(m2a2)
  ## ##             effect component std.error z.ratio bound %ch
  ## ##              block   0              NA      NA     B  NA
  ## ##         block:fung   0.01206  0.01512      0.8     P   0
  ## ##              units   0.02463  0.002465    10       P   0
  ## ##       rowf:bedf(R)   1              NA      NA     F   0
  ## ## rowf:bedf!rowf!cor   0.8836   0.03646     24       U   0
  ## ## rowf:bedf!rowf!var   0.1261   0.04434      2.8     P   0
  ## ## rowf:bedf!bedf!cor   0.9202   0.02846     32       U   0

  ## wald(m2a2)
}

}

