# CityExperienceiOSTest

## Goal:

| Goal               |
| ------------------ |
| List the articles, display the following for each article: Source name, Author, Title, Image (If available)
| When clicking on the item/row, it should take you to a DetailViewController, where it shows detailed info such as: Source name, Author, Title, Image (If available), Content
| Infinite scrolling
| Pull to refresh
| Use searchbar to dynamically fetch content related to user’s search

## Library Usage

| Library               | Usage
| ------------------ | -----
| Alamofire | Network Call
| SnapKit | AutoLayout 
| SDWebImage | Async download image and cahce image

## Usage

As there is difficulty in applying API key, this project is divided in 2 parts: <br> 
First part is using dummy json respond and view model to demostrate basic funcion with image and content. <br> 
The advance fucntion do not work with first when using dummy view model.<br> <br>

Second part is using normal view model to demostrate advanced function. <br> 
Following steps are prerequestie.

## Prerequestie to use dummy json

Update the NewsListViewController: <br> 
Amend line 13 to initialize DummyNewsViewModel <br>
Add newsViewModel.getDummyNews() in viewDidLoad to fetch the respond

![](DummyViewModel.png)

## Prerequestie to use the real api

Update the NewsListViewController: <br>
Amend line 13 to initialize NewsViewModel <br>
Delete newsViewModel.getDummyNews() in viewDidLoad

![](NewsViewModel.png)

Insert the APIKey in NewsService

![](APIKey.png)

## Flow of result:

BasicFunction - 

![](BasicFunction.gif)

Advanced Function - 

![](AdvancedFunction.gif)

## Sreenshoot:

ListViewController - 

![](ListViewController.png)

DetailViewController -

![](DetailViewController.png)

Search -

![](Search_1.png) ![](Search_2.png)

Infinite Scrolling -

![](LoadMore_1.png) ![](LoadMore_2.png)

Pull To refresh -

![](PullToReload.png)
