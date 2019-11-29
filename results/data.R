library("reshape2")
library("plyr")
library("ggplot2")

base = '/home/cecylia/Documents/slitheen/tests/new/'
    replaced = c()
    total = c()
for(i in (1:10)){
for (dir in (1:10)){

    filename = paste(base, dir, '/metrics-',i,'.csv', sep="")

    if(file.exists(filename)){


        data = read.csv(filename, header = TRUE)
        bandwidth = ddply(data,.(time),numcolwise(sum))

        bandwidth[,1] = bandwidth[,1] - bandwidth[1,1]
        bandwidth[,2] = cumsum(bandwidth[,2])*8/1000
        bandwidth[,3] = cumsum(bandwidth[,3])*8/1000

        total_time = bandwidth[length(bandwidth[,1]),1]
        total_total = bandwidth[length(bandwidth[,1]),2]
        total_replaced = bandwidth[length(bandwidth[,1]),3]

        total = c(total, total_total/total_time)
        replaced = c(replaced, total_replaced/total_time)

    }
}

}

#calculate overhead
o = read.csv(paste(base, 'overhead.csv', sep=""), header = FALSE)

ot = cbind(o[,1]*8/1000, total)

print("Overhead")
print(mean(ot[,1]/ot[,2]))
print(sd(ot[,1]/ot[,2]))


print("Throughput")
print(mean(total))
print(mean(replaced))

print(sd(total))
print(sd(replaced))

print(median(total))
print(median(replaced))

print(max(total))
print(max(replaced))
print(min(total))
print(min(replaced))
