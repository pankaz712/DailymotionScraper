###### loading required libraries

library(curl)
library(rvest)
library(dplyr)


## first scrap the main index

main.idx = "https://www.dailymotion.com/archived/index.html"    # this is the primary Url for the archives
wbpg.tmp = read_html(main_url)
urls.level.zero = html_nodes(wbpg.tmp, '.foreground2') %>% html_attr('href')
nc = grepl(pattern = '2014|2015',urls.level.zero)    # subsetting only the years that are needed
urls.level.zero = urls.level.zero[which(nc==T)]

# outer loop
mydf = data.frame()      # empty data frame to store titles and urls

for(i in 1:length(urls.level.zero)){
  closeAllConnections()
  url.tmp = paste0("https://www.dailymotion.com",urls.level.zero[i])
  print(url.tmp)
  wbpg.tmp = tryCatch(
    
    read_html(url.tmp),
    error = function(e) e
    
  )
  
  if(inherits(wbpg.tmp,"error")){
    next
  }
  urls.level.one = html_nodes(wbpg.tmp, '.foreground2') %>% html_attr('href')
  vc = which(grepl(pattern = "Noon|Morning|Evening",x = urls.level.one)==TRUE)
  urls.level.one = urls.level.one[vc]
  
  for(j in 1:length(urls.level.one)){
    closeAllConnections()
    url.tmp = paste0("https://www.dailymotion.com",urls.level.one[j])
    print(url.tmp)
    
	wbpg.tmp = tryCatch(
      
      read_html(url.tmp),
      error = function(e) e
      
    )
    
    if(inherits(wbpg.tmp,"error")){
      next
    }
    urls.level.two = html_nodes(wbpg.tmp, '.label') %>% html_attr('href')
    urls.level.two =  urls.level.two[-is.na(urls.level.two)]
    urls.level.two = paste0("https://www.dailymotion.com",urls.level.two)
    m1 = multi_get(service.urls = urls.level.two)
    
    for(k in 1:length(m1)){
      
      wbpg.tmp = tryCatch(
        
        read_html(unlist(m1[k])),
        error = function(e) e
    
      )
      
      if(inherits(wbpg.tmp,"error")){
        next
      }
      
      heading = html_nodes(wbpg.tmp, '.video_title')
      text = html_text(heading)
      urls = html_nodes(wbpg.tmp, '.video_title') %>% html_attr('href')
      tmp = data.frame(title = text,urls = urls)
      mydf = rbind(mydf,tmp)
            
    }
  
    Sys.sleep(time = 1)
    
  }
}

##################################

write.csv(x = mydf,file = "mydf.csv")



