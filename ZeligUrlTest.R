library(xml2, rvest)

test_web_vignettes <- function() {
  ## Assumes that the current working directory is Zelig package top directory

  
  setwd("docs")
  setwd("articles")
  articles <- list.files(pattern = "html")
  for (article in articles) {
    links <- get_links(article)
    for (link in links) {
      ## do test on link
      ## if link broken, add article and link to the dataframe storing them
      
    }
  }
  
  ## Clean Up Code
  setwd("..")
  setwd("..")
  
  ## Return dataframe of broken links
  
}

#' Parses an html document and returns a vector of all links in the document
#' 
#' 
#' @author Ben Sabath
#' @return Vector of urls
#'
get_links <- function(html_doc) {
  doc <- read_html(html_doc)
  links <- html_attr(html_nodes(doc, "a"))
  links <- links[!links %in% "#"]
  return(links)
}

