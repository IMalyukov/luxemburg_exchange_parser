##### packages #####

#install.packages("V8")
#install.packages("RSelenium")
#install.packages("readtext")
#install.packages("webdriver")
#Sys.setenv(R_REMOTES_STANDALONE="true") ### for github packages installing
#install_github("selesnow/getProxy")
#remotes::install_github("selesnow/getProxy")


##### libraries #####
library(data.table)
library(readxl)
library(rvest)
library(xml2)
library(tidyr)
#library(XML)
#library(searcher)
library(httr)
#library(V8)
#library(RSelenium)
library(webdriver)
library(getProxy)

##### Bourse.lu #####

links <- read.csv("linkses.csv")
links$source <- as.character(links$source)
links$bourse_lu.isin <- as.character(links$bourse_lu.isin)
links <- links[93:nrow(links),]
links <- na.omit(links)

##### headless browser ##### 
## guide https://slcladal.github.io/webcrawling.html
#webdriver::install_phantomjs() ##### install the phantomJS headless browser. This needs to be done only once.

### start an instance of PhantomJS and create a new browser session that awaits to load URLs to render the corresponding websites.
pjs_instance <- run_phantomjs() 
pjs_session <- Session$new(port = pjs_instance$port)

main_dir <- "C:/Users/Илья/Desktop/По работе главн/парсинг"

##### big cycle #####
for (i in 1:162) {
  pjs_session$go(links$source[i])
  Sys.sleep(2)
  rendered_source <- pjs_session$getSource()
  Sys.sleep(2)
  html_document <- read_html(rendered_source)
  Sys.sleep(2)
  
  html_links <- html_document %>%
    html_nodes(xpath = '//*[@class="fiche-section-prospectus fiche-section-container"]//li[@class = "vignette-list-item"]/a') %>%
    html_attr('href')
  
  print(length(html_links))
  
   for (k in 1:length(html_links)) {
    n <- as.character(k)
    sub_dir_new <- links$bourse_lu.isin[i]
    dir.create(file.path(main_dir, sub_dir_new))
    dest <- paste0("C:\\Users\\Илья\\Desktop\\По работе главн\\парсинг\\", sub_dir_new, "\\", sub_dir_new, "_", n, ".pdf")
    download.file(html_links[k], destfile = dest, mode = "wb")
    Sys.sleep(7)
  }
  print(i)
  
}

links$source[161]

#options(timeout = 15)
#if (is.na(html_links[1] == T)) {
#  print(links$source[i]) }
##### miscanselous ######
#?download.file()
# getProxy(notCountry = "RU", action = "start")

#sub_dir_new <- links$bourse_lu.isin[10]
#dir.create(file.path(main_dir, sub_dir_new))
#paste0("C:\\Users\\Илья\\Desktop\\По работе главн\\парсинг\\", sub_dir_new, "\\", sub_dir_new, "_", n, ".pdf")



  

##### scan and parse webpage with hb #####
# go to URL
pjs_session$go(links$source[1])
# render page
rendered_source <- pjs_session$getSource()
# download text and parse the source code into an XML object
html_document <- read_html(rendered_source)

##### get the needed links ####
html_links <- html_document %>%
  html_nodes(xpath = '//*[@id="page-fiche"]/div[2]/div[4]/ul/li/a') %>%
  html_attr('href')

html_links
##### cicle #####
## https://statisticsglobe.com/check-in-r-if-directory-exists-and-create-if-it-does-not 

for (i in 1:3) {
  n <- as.character(i)
  dest <- paste0("C:\\Users\\Илья\\Desktop\\По работе главн\\парсинг\\USP8000UAA71_", n, ".pdf")
  download.file(html_links[i], destfile = dest, mode = "wb")
  
}



