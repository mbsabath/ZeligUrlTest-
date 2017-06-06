library(xml2)
library(rvest)
library(httr)

test_web_vignettes <- function() {
  ## Assumes that the current working directory is Zelig package top directory

  bad_articles <- "" ## Hacky declare to allow for later append
  bad_links <- ""
  setwd("docs")
  setwd("articles")
  articles <- list.files(pattern = "html")
  for (article in articles) {
    links <- get_links(article)
    for (link in links) {
     if (bad_link(link)) {
       bad_articles <- c(bad_articles, article)
       bad_links <- c(bad_links, link)
     }
    }
   }
  
  ## Clean Up Code
  setwd("..")
  setwd("..")
  bad_articles <- bad_articles[2:length(bad_articles)] ## Clean up earlier hack
  bad_links <- bad_links[2:length(bad_links)] 
  
  
  return(data.frame(bad_articles,bad_links))
  

  
}

#' Parses an html document and returns a vector of all links in the document
#' 
#' 
#' @author Ben Sabath
#' @return Vector of urls
#'
get_links <- function(html_doc) {
  doc <- read_html(html_doc)
  links <- html_attr(html_nodes(doc, "a"), "href")
  links <- clean_links(links)
  return(links)
}

clean_links <- function(links) {
  link_head <- "http://docs.zeligproject.org"
  article_head <- "http://docs.zeligproject.org/articles/"
  ## Remove internal page tags
  links <- links[substr(links,1,1) != "#"]
  ## append website to links to other directories
  dotdots <- substr(links,1,2) == ".."
  links[dotdots] <- paste(link_head,substring(links[dotdots],3),sep="")
  ## append article lead to remaining
  not_http <- substr(links,1,4) != "http"
  links[not_http] <- paste(article_head,links[not_http],sep="")
  
  return(links)
}

bad_link <- function(link) {
  pg <- GET(link)
  return(pg$status != 200)
}