# Load the Library
library(RSelenium)

library(dplyr)
library(stringr)
library(rvest)
library(knitr)
library(kableExtra)


# start the server and browser(you can use other browsers here)
rD <- rsDriver(port=4723L, chromever="83.0.4103.39")

driver <- rD$client

# navigate to an URL
driver$navigate("http://books.toscrape.com/")

#close the driver
driver$close()

#close the server
rD$server$stop()



# 2.2.2. Navigating to different URLs

# Using driver.navigate():
driver$navigate("http://books.toscrape.com/")

# simulating click

# navigate to an URL
driver$navigate("http://toscrape.com/")

# find the element
elements <- driver$findElements("a",using = "css")

# click the first link 
elements[[1]]$clickElement()

# Go Back or Go Forward
driver$goBack()
driver$goForward()




# 2.2.3. Simulating Scrolls, Clicks, Text Inputs, Logins, and Other Actions

# 1. Simulating Scrolls:

# Scroll Down Once:

driver$navigate("http://quotes.toscrape.com/scroll")
# find the webpage body
element <- driver$findElement("css", "body")
#scroll down once ----
element$sendKeysToElement(list(key = "page_down"))


# Scroll Down Multiple Times:
  
Scroll Down Multiple Times:
  
element <- driver$findElement("css", "body")
# Scroll down 10 times
for(i in 1:10){
  element$sendKeysToElement(list("key"="page_down"))
  # please make sure to sleep a couple of seconds to since it takes time to load contents
  Sys.sleep(2) 
}


#Scroll Down Until the End(Not Recommended if There Are too Many Pages):
  
element <- driver$findElement("css", "body")
flag <- TRUE
counter <- 0
n <- 5

while(flag){
  counter <- counter + 1
  #compare the pagesource every n(n=5) time, since sometimes one scroll down doesn't render new content
  for(i in 1:n){
    element$sendKeysToElement(list("key"="page_down"))
    Sys.sleep(2)
  }
  if(exists("pagesource")){
    if(pagesource == driver$getPageSource()[[1]]){
      flag <- FALSE
      writeLines(paste0("Scrolled down ",n*counter," times.\n"))
    } else {
      pagesource <- driver$getPageSource()[[1]]
    }
  } else {
    pagesource <- driver$getPageSource()[[1]]
  }
}



######### Simulating Clicks:
  
# Click a Single Element by CSS:
  
driver$navigate("http://quotes.toscrape.com/scroll")

#locate element using CSS(find the first match)
driver$navigate("https://scrapethissite.com/pages/ajax-javascript/#2011")
element <- driver$findElement(using = "css",".year-link")
element$clickElement()

# Click a Single Element by Moving Mouse to Element:
driver$navigate("https://scrapethissite.com/pages/ajax-javascript/#2011")
element <- driver$findElement(using = "css",".year-link")
driver$mouseMoveToLocation(webElement = element)
driver$click()

#Click Multiple Items:
driver$navigate("https://scrapethissite.com/pages/ajax-javascript/#2011")
elements <- driver$findElements(using = "css",".year-link")
for(element in elements){
  element$clickElement()
  Sys.sleep(2)
}

#Go to Different URLs by Clicking Links:
driver$navigate("http://books.toscrape.com/")
elements <- driver$findElements(using = "css",".nav-list ul a")
for(i in 1:length(elements)){
  elements[[i]]$clickElement()
  Sys.sleep(2)
  #do something and go back to previous page
  driver$goBack()
  Sys.sleep(1)
  # refresh the elements
  elements <- driver$findElements(using = "css",".nav-list ul a")
}


# 3. Simulating Text Input:
  
# Enter Text and Search
driver$navigate("https://www.google.com/")
#selcet input box
element <- driver$findElement(using = "css",'input[name="q"]')
#send text to input box. don't forget to use `list()` when sending text
element$sendKeysToElement(list("Web Scraping"))
#select search button
element <- driver$findElement(using = "css",'input[name="btnK"]')
element$clickElement()

#Clear Input Box
driver$navigate("https://www.google.com/")
#selcet input box
element <- driver$findElement(using = "css",'input[name="q"]')
element$sendKeysToElement(list("Web Scraping"))
#clear input box
element$clearElement()


# 4. Logins:
  
# Login is simple using RSelenium. Instead of doing post request, it's just a combination of sending texts to input boxes and click login button.

driver$navigate("http://quotes.toscrape.com/login")
#enter username
element <- driver$findElement(using = "css","#username")
element$sendKeysToElement(list("myusername"))
#enter password
element <- driver$findElement(using = "css","#password")
element$sendKeysToElement(list("mypassword"))
#click login button
element <- driver$findElement(using = "css", 'input[type="submit"]')
element$clickElement()


# 5. Simulating Key and Button Presses:
  
# You can also send keys to the browser, you can check all available keys by running RSelenium::selKeys.

# Send Key Combinations:
  
driver$navigate("https://scrapethissite.com/pages/ajax-javascript/#2015")
Sys.sleep(2)
# Press Control+A to select the entire page
driver$findElement(using = "css","body")$sendKeysToElement(list(key="control","a"))

