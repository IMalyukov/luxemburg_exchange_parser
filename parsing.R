data <- read.csv("Euronext_Bonds_2022-05-05.csv",sep = ";")
tabled <- read.csv("tabled.csv", sep = ",", header = F)

library(data.table)
library(readxl)
library(rvest)
library(xml2)
library(tidyr)

poisk <- read_excel("Poisk.xlsx")

new_table <- merge(data, poisk, by = "ISIN")

selector <- read_excel("bond_selector_result.xls")
##### html #####
html <- read_html("https://www.sgx.com/securities/prospectus-circulars-offer-documents?prospectusType=Prospectus&page=1&pagesize=100")
html_structure(html)

body_node <- html %>%
  html_node('body')

html %>%
  html_table()

lunk <- html %>% 
  html_node('#page-container > template-base > div > div > sgx-widgets-wrapper > widget-filter-listing > widget-filter-listing-prosp-circ-offers > section > div.widget-filter-listing-result-pages.col-xs-12.col-md-9 > div')

body_node %>%
  html_nodes('.article-list-result')

#####
lunk

id_or_class_xp <- "//div[@class='article-list-result']//text()"
xpathSApply(html,id_or_class_xp,xmlValue)




html %>% html_children() %>% html_text()

html_nodes(html, xpath = "//*[@id='page-container']")

xml_attrs(xml_child(xml_child(xml_child(xml_child(xml_child(html, 2), 3), 1), 1), 3))[["id"]]




###### Divide column name on Issuer name and other information ######
tabled2 <- read.csv("tabled2.csv", sep = ",")
tabled3 <- read.csv("tabled3.csv", sep = ",")
new_poisk <- separate(poisk, name, into = c("Issuer", "Conditions", "Currency"), sep = ",")
new <- as.data.table(new_poisk)
new
mega <- new[exchange == "Сингапурская ФБ"]
colnames(tabled) <- c("data", "Issuer", "Important", "NotIM")

  
new_table_2 <- merge(mega, tabled3, by = "Issuer")
new_table_2$Important



##### Bourse.lu #####
library(XML) # HTML processing
options(stringsAsFactors = FALSE)

install.packages("searcher") ##### search
library(searcher)

library(rvest)



# Load the page
library(data.table)
bourse_lu <- read_excel("bourselu.xlsx")

links <- data.frame(matrix(NA, nrow = 292, ncol = 1))
colnames(links) <- "source"


for (i in 1:292) {
  main.page <- read_html(paste0("https://www.google.com/search?q=", bourse_lu$isin[i], "+bourse+lu"))
  
  main.p <- main.page %>% 
    html_nodes("a") %>% # get the a nodes with
    html_attr("href") # get the href attributes
  
  beach <- paste0("https://www.bourse.lu/security/", bourse_lu$isin[i], "/\\d{6}$")
  
  #clean the text  
  main.p = gsub('/url\\?q=','',sapply(strsplit(main.p[as.vector(grep('url',main.p))],split='&'),'[',1))
  main.p <- as.character((main.p[grepl(beach, main.p)]))
  print(main.p)
  # as a dataframe
  if (length(main.p) != 0) {links$source[i] <- main.p} 
 # websites <- data.frame(links = links, stringsAsFactors = T)
  
 # if (i == 292) { websites <- data.frame(links = links, stringsAsFactors = FALSE) }
}

beach

write.csv(links, file = "linkses.csv",row.names = F)

sum(is.na(links$source))







### yuRUbf

yuRUbf <- div %>%
  html_nodes('a') %>%
  html_attr("href")
yuRUbf[15]

#clean the text  
links = gsub('/url\\?q=','',sapply(strsplit(links[as.vector(grep('url',links))],split='&'),'[',1))
# as a dataframe
websites <- data.frame(links = links, stringsAsFactors = FALSE)
View(websites)

length(bourse_lu$isin)


# Base URL
base.url = ''
download.folder = '~/Downloads/schools/'









##### Copy code #####
library(XML) # HTML processing
options(stringsAsFactors = FALSE)

# Base URL
base.url = 'http://www.educationcounts.govt.nz/find-a-school/school/national?school='
download.folder = '~/Downloads/schools/'

# Schools directory
directory <- read.csv('Directory-Schools-Current.csv')
directory <- subset(directory, 
                    !(school.type %in% c("Secondary (Year 9-15)", "Secondary (Year 11-15)")))

# Reading file obtained from stuff.co.nz obtained from here:
# http://schoolreport.stuff.co.nz/index.html
fairfax <- read.csv('SchoolReport_data_distributable.csv')
fairfax <- subset(fairfax, !is.na(reading.WB)) 

# Defining schools with missing information
to.get <- merge(directory, fairfax, by = 'school.id', all.x = TRUE)
to.get <- subset(to.get, is.na(reading.WB))

# Looping over schools, to find name of PDF file
# with information and download it

for(school in to.get$school.id){
  
  # Read HTML file, extract PDF link name
  cat('Processing school ', school, '\n')
  doc.html <- htmlParse(paste(base.url, school, sep = ''))
  doc.links <- xpathSApply(doc.html, "//a/@href")
  pdf.url <- as.character(doc.links[grep('pdf', doc.links)])
  if(length(pdf.url) > 0) {
    pdf.name <- paste(download.folder, 'school_', school, '.pdf', sep = '')
    download.file(pdf.url, pdf.name, method = 'auto', quiet = FALSE, mode = "w",
                  cacheOK = TRUE, extra = getOption("download.file.extra"))
  }
}