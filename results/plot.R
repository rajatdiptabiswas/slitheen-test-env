library("reshape2")
library("plyr")
library("ggplot2")

base = '/home/cecylia/Documents/slitheen/tests/new/'
for(i in (1:10)){
    total_plot = ggplot()
    replaced_plot = ggplot()
for (dir in (1:10)){

    filename = paste(base, dir, '/metrics-',i,'.csv', sep="")

    if(file.exists(filename)){

        print(filename)

        data = read.csv(filename, header = TRUE)
        bandwidth = ddply(data,.(time),numcolwise(sum))

        bandwidth[,1] = bandwidth[,1] - bandwidth[1,1]
        bandwidth[,2] = cumsum(bandwidth[,2])
        bandwidth[,3] = cumsum(bandwidth[,3])

        bw_plot = ggplot(data = bandwidth, aes(x=time, y=(goodput/1000000), group=1)) + geom_step() +
            labs(x='Time (s)', y='Data received (MB)') +
            theme(text = element_text(size=20,family="Times")) + theme_bw() + theme(text = element_text(size=20,family="Times")) +
            scale_y_continuous(expand=c(0,0), limits=c(0,11)) +
            scale_x_continuous(expand=c(0,0))

        total_plot = total_plot + geom_step(data = bandwidth, aes(x=time, y=(goodput/1000000), group=1))

        png(filename=paste(base,dir,'/total',i,'.png', sep=""))
        plot(bw_plot)
        dev.off()

        bw_plot = ggplot(data = bandwidth, aes(x=time, y=(replaced/1000000), group=1)) + geom_step() +
            labs(x='Time (s)', y='Data received (MB)') +
            theme(text = element_text(size=20,family="Times")) + theme_bw() + theme(text = element_text(size=20,family="Times"))

        replaced_plot = replaced_plot+geom_step(data = bandwidth, aes(x=time, y=(replaced/1000000), group=1))
        png(filename=paste(base,dir,'/replaced',i,'.png', sep=""))
        plot(bw_plot)

        
        #bw_plot = ggplot(bandwidth, aes(time, goodput/1000)) +
        #    geom_point() +
        #    geom_smooth() +
        #    xlab("Time") +
        #    ylab("# of transferred bytes") +
        #    theme_minimal()
        #png(filename=paste('something',i,'.png', sep=""))
        #plot(bw_plot)
        dev.off()
    
    }
    total_plot = total_plot + 
            labs(x='Time (s)', y='Data received (MB)') +
            theme(text = element_text(size=20,family="Times")) + theme_bw() + theme(text = element_text(size=20,family="Times")) +
            scale_y_continuous(expand=c(0,0), limits=c(0,11)) +
            scale_x_continuous(expand=c(0,0))
        png(filename=paste(base,'/total-',i,'.png', sep=""))
        plot(total_plot)
        dev.off()
    replaced_plot = total_plot + 
            labs(x='Time (s)', y='Data received (MB)') +
            theme(text = element_text(size=20,family="Times")) + theme_bw() + theme(text = element_text(size=20,family="Times")) +
            scale_y_continuous(expand=c(0,0), limits=c(0,11)) +
            scale_x_continuous(expand=c(0,0))
        png(filename=paste(base,'/replaced-',i,'.png', sep=""))
        plot(replaced_plot)
        dev.off()
}

}
