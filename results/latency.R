library(ggplot2)

args <- commandArgs(trailingOnly = TRUE)
data <- read.csv(args[1], header=TRUE)

x <- data[,3]

ggplot(data, aes(x=x)) +
  stat_ecdf(show.legend=FALSE) + labs(x='Latency (s)', y='CDF') +
  theme(text = element_text(size=20,family="Times")) + theme_bw() + theme(text = element_text(size=20,family="Times")) + 
  scale_x_continuous(expand=c(0,0), limits=c(0,31)) + 
  scale_y_continuous(expand=c(0,0))

  ggsave("latency.pdf",
       width = 7,
       height = 5)

  print(mean(x))
  print(sd(x))
  print(median(x))
  print(min(x))
  print(max(x))
