require(xml2)
library("xml2")
query<- 'term=(changhua+christian+hospital)+AND+(hsieh+mc%5BAUTHOR%5D)'
result.urls<-paste('https://www.ncbi.nlm.nih.gov/pubmed/', query, sep='?')

html.page = read_html(url(result.urls[1]))
xpath<-"//*[@class='rslt']/p/a"
target<-xml_find_all(html.page,xpath)
title<-xml_text(target) 

xpath1<-"//*[@class='supp']/p/span"
target1 = xml_find_all(html.page, xpath1)
Journal_title = xml_text(target1)

xpath2<-"//*[@class='supp']/p"
target2 = xml_find_all(html.page, xpath2)
title2 = xml_text(target2)
author<-title2[c(1,3,5,7,9,11,13,15,17,19)]
year<-title2[c(2,4,6,8,10,12,14,16,18,20)]

page.info = data.frame(title,Journal_title,author,year)

#################################################################
html.page = read_html(url(result.urls[1]))
xpath = "//*[@class='rslt']/p/a"
target = xml_find_all(html.page, xpath)
attr<-xml_attr(target,'href')
url_attr<-paste('https://www.ncbi.nlm.nih.gov',attr,sep='')


index<-c()
for(j in 1:length(url_attr)){
  i=url_attr[j]
  print(i)
  xpath_author<-'//*[@id="maincontent"]/div/div[@class="rprt_all"]//div[@class="auths"]/a'
  html.page2<-read_html(url(i))
  target1<-xml_find_all(html.page2,xpath_author)
  author<-xml_text(target1)
  
  xpath_label<-'//*[@id="maincontent"]/div/div[@class="rprt_all"]//div[@class="auths"]/sup'
  target2<-xml_find_all(html.page2,xpath_label)
  author_label<-xml_text(target2)
  p_vector1<-paste(author_label,collapse='-')
  m<-gsub("#-", "", p_vector1)
  m1<-gsub(",-", ",", m)
  spli_t<-strsplit(m1,"-")[[1]]
  doctor_place<-spli_t[which(author=="Hsieh MC")]
  spli_t2<-strsplit(doctor_place, ",")[[1]]
  
  xpath_hospital<-'//*[@id="maincontent"]/div/div[@class="rprt_all"]//div[@class="afflist"]//dl[@class="ui-ncbi-toggler-slave"]/dd'
  target3<-xml_find_all(html.page2,xpath_hospital)
  hospital<-xml_text(target3)
  #need to write the for loop inside the first loop
  hospital_place1<-hospital[as.integer(spli_t2)]
  #counts_1<-gsub(" ", "", strsplit(hospital_place1, ",")[[1]])=="ChanghuaChristianHospital"
  grep_place<-grep("Changhua Christian Hospital", hospital_place1, value=F)
  if(length(grep_place)>0){ 
      index<-c(index,j) }
}
index
page.info[index,]
write.csv(page.info, file = 'C:/Users/RCHEN/Desktop/Rcode/title.txt', row.names = TRUE)
#grep("^A", year, value=TRUE)
#grep("^A", year, value=F)
##word <- c('abc noboby@stat.berkeley.edu','text with no email','first me@mything.com also you@yourspace.com')
##pattern <- '[-A-Za-z0-9_.%]+@[-A-Za-z0-9_.%]+\\.[A-Za-z]+'
##gregout <- gregexpr(pattern,word)
