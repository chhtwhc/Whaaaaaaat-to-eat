# 朱訓宏 CHU HSUN HUNG 12/10 final presentatation - R code
## 等等吃什麼！ ##

# 安裝爬蟲套件 #
#install.packages("rvest")
#install.packages("magrittr")

# 建立資料庫 #
    # 小問題：不能有重複的
    # 升級：直接讀excel
    # 升級：直接抓google map
data = read.delim("https://raw.githubusercontent.com/chhtwhc/Whaaaaaaat-to-eat/master/WTE_list.txt", header = T, row.names = 1)
# 選店 #
    # 升級：加入opentime type(function, if, which都要改)
    # 升級：條件可以複選
what_to_eat = function(restaurant_list,location, price)
{
  if(price == "all")
  {
    where = which(restaurant_list$location == location)
    what_to_eat_list = row.names(restaurant_list)[where]
    what_to_eat_decide = what_to_eat_list[sample(1:length(what_to_eat_list), size = 1)]
  }else{
  if(location == "all")
  {
    money = which(restaurant_list$price == price)
    what_to_eat_list = row.names(restaurant_list)[money]
    what_to_eat_decide = what_to_eat_list[sample(1:length(what_to_eat_list), size = 1)]
  }else{
    where = which(restaurant_list$location == location)
    money = which(restaurant_list$price == price)
    what_to_eat_list = row.names(restaurant_list)[intersect(where, money)]
    what_to_eat_decide = what_to_eat_list[sample(1:length(what_to_eat_list), size = 1)]
  }}
  return(what_to_eat_decide)
}
# 操作視窗 #
    # 升級：字變大
    # 升級：加上顏色
    # 升級：丟上雲端 → 手機也能用

# install.packages("shiny")
# install.packages("shinythemes")
library(shiny)
library(shinythemes)
# 使用者視窗
ui = fluidPage(
  # 0. change the theme
  theme = shinytheme("readable"),
  # 1. Whole design title
  titlePanel("What to eeeeeeeeeeeeat !!!"),
  
  sidebarLayout(
    sidebarPanel(width = "80px",
      # 2. Input design use checkboxGroupInput
      selectInput("budget", 
                  label = "Your Budget",
                  choices = list("$" = "$", "$$" = "$$", "$$$" = "$$$", "$$$$" = "$$$$", "$$$$$" = "$$$$$", "All" = "all"),
                  multiple = F, width = "800px"),
      selectInput("area",
                  label = "Where to eat",
                  choices = list("NTU" = "NTU", "R.nan" = "R.nan", "Guan" = "Guan", "dorm" = "dorm", "NTUE" = "NTUE", "NTUST" = "NTUST", "118" = "118", "six" = "six", "All" = "all"),
                  multiple = F, width = "800px"),
      actionButton("action", label = "I'm so HUNGRY !")
    ),   
    mainPanel(
      # 3. Output design use textOutput
      h1(textOutput("requirement"))
    )
  )
)
# 後台處理
server = function(input, output) {
    final_eat <- eventReactive(input$action, {
      what_to_eat(data, location = input$area, price = input$budget)
    })
    output$requirement = renderText({
      final_eat()
    })
}

# 輸出結果 #
shinyApp(ui, server)

# 線上化 #
# install.packages('rsconnect')
# setwd("D:\\CHU 2.0\\Forest\\108-1 R for ecology\\r final project\\server and ui")
library(rsconnect)
rsconnect::setAccountInfo(name='chhtwhc',
                          token='7062539489DA6321DDBA8675A3E6ECC7',
                          secret='pOxynOYL3IXK0bVzznWjQE3Wjy5uWsgP4z1xGpEB')
deployApp() # 目前可以deploy但無法執行
