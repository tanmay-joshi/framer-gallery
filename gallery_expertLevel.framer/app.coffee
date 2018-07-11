# Set Device background
Screen.backgroundColor = "white"
Canvas.image = Utils.randomImage(Canvas.size)

#data
galleryData = JSON.parse Utils.domLoadDataSync "data/galleryData.json"

# Bottom Tabs
class Filters extends Layer
	constructor: (@options={}) ->
		@options.width = Screen.width/5
		@options.height = Screen.width/5
		@options.backgroundColor = "#eeeeee"
		
		@Thumbnail = new Layer	
		
		@FilterName = new TextLayer
		
		super @options
		
		@Thumbnail.parent = @
		@FilterName.parent = @
		
		@Thumbnail.width = @options.width/2
		@Thumbnail.height = @options.height/2
		@Thumbnail.x = Align.center
		@Thumbnail.y =Align.top(6)
		@Thumbnail.backgroundColor = "#000000"
		
		@FilterName.fontSize = 12
		@FilterName.width = @options.width * 0.8
		@FilterName.height = @options.height /2
		@FilterName.color = "#333333"
		@FilterName.padding = @options.width * 0.05
		@FilterName.textAlign = "center"
		@FilterName.x = Align.center
		@FilterName.y = Align.bottom(8)

#parent Scroll
scroll = new ScrollComponent
	size: Screen.size
	scrollHorizontal: false


# Card Component
class card extends Layer
	constructor: (@options={}) ->
		@options.width = Screen.width/4
		@options.height = Screen.width/4
		#@options.image = Utils.randomImage()
		@options.borderColor = "#ffffff"
		@options.borderWidth = 3
		@options.type = "audio"
		
		@identity = new TextLayer
		super @options
		
		@identity.parent = @
		@identity.fontSize = 9
		@identity.color = "#ffffff"
		@identity.backgroundColor = "#aaaaaa"
		@identity.width = 12
		@identity.height = 12
		@identity.x = Align.right(-2)
		@identity.y = Align.top(8)
		@identity.textAlign = "center"
		@identity.text ?= "A"
		@identity.fontWeight = "bold"
		@identity.borderRadius = 3

class Day extends Layer
	constructor: (@options={}) ->
		@options.width = Screen.width
		@options.backgroundColor = "#fefefe"
		@options.y ?= 0
		
		@DayName = new TextLayer
		@DayContent = new Layer
		super @options
		
		@DayName.parent = @
		@DayName.text = ""
		@DayName.fontSize = 18
		@DayName.padding = 12
		@DayName.color = "#333333"
		
		@DayContent.parent = @
		@DayContent.y = @DayName.height
		@DayContent.width = Screen.width
		@DayContent.height ?= 400
		@DayContent.backgroundColor = "#ffffff"

###
Day = new Layer
	width: Screen.width
	backgroundColor: "#eeeeee"

DayName = new TextLayer
	text: "Today"
	fontSize: 18
	padding: 12
	parent: Day
	color: "#333333"

DayContent = new Layer
	parent: Day
	y: DayName.height
	width: Screen.width
	backgroundColor: "#ffffff"
###




BottomBarInfo = [
	{
		"icon": "#333333", "name": "All", "dataType": "ALL"
	},
	{
		"icon": "#343333", "name": "Image", "dataType": "I"
	},
	{
		"icon": "#353333", "name": "Video", "dataType": "V"
	},
	{
		"icon": "#363633", "name": "Audio", "dataType": "A"
	},
	{
		"icon": "#373333", "name": "GIF", "dataType": "G"
	},
]


BotttomBar = new Layer
	width: Screen.width
	height: Screen.width/5
	y: Align.bottom
	z: 1

BottomTabs = []

for info, i in BottomBarInfo
	Tab = new Filters
	Tab.Thumbnail.backgroundColor = info.icon
	Tab.FilterName.text = info.name
	Tab.x = 0 + (i * Screen.width/5)
	Tab.name = info.name
	Tab.dataType = info.dataType
	BottomTabs.push(Tab)
	Tab.parent = BotttomBar


#funtion to resize the day component
reSize = (theDay) ->
	theDay.DayContent.height = (rowIndex + 1) * cardWidth
	theDay.height= theDay.DayName.height + theDay.DayContent.height


columnCount = 4
cardWidth = Screen.width/4

cards = []

daysData = [
	{
		"name": Object.keys(galleryData)[0], "id": "day1"
	},
	{
		"name": Object.keys(galleryData)[1], "id": "day2"
	}
]

days = []

YDay = 0

for a in [0...2]
	newDay = new Day
	newDay.DayName.text = daysData[a].name
	newDay.y = YDay
	newDay.parent = scroll.content
	

	newDay.name = daysData[a].name
	#print "Y"
	days.push(newDay)
	length = galleryData[daysData[a].name].length
	
	for index in [0...length]
			columnIndex = index % columnCount
			rowIndex = Math.floor(index / columnCount)
		
			caard = new card
				x: (columnIndex * cardWidth)
				y: rowIndex * cardWidth
				parent: newDay.DayContent
				image: galleryData[daysData[a].name][index].thumb
			caard.identity.text = galleryData[daysData[a].name][index].dataType
			cards.push(caard)
		
		reSize(newDay)
		YDay += newDay.height
		dataTypeVariable = ""

o = 0

for i in [0...5]
	BottomTabs[i].onClick ->
		#print "ya"
		dataTypeVariable = this.dataType
		#print dataTypeVariable
		for a in [0...days.length]
			days[a].destroy()
			
		Xday = 0
		days = []
		
		index = -1
		for a in [0...2]
			newDay = new Day
			newDay.DayName.text = daysData[a].name
			newDay.y = Xday
			newDay.parent = scroll.content
			
		
			newDay.name = daysData[a].name
			#print "Y"
			days.push(newDay)
			length = galleryData[daysData[a].name].length
			
			if dataTypeVariable == "ALL"
				for indx in [0...length]
					columnIndex = indx % columnCount
					rowIndex = Math.floor(indx / columnCount)
				
					caard = new card
						x: (columnIndex * cardWidth)
						y: rowIndex * cardWidth
						parent: newDay.DayContent
						image: galleryData[daysData[a].name][indx].thumb
					caard.identity.text = galleryData[daysData[a].name][indx].dataType
					cards.push(caard)
			else
				#print keys
				for z in [0...galleryData[daysData[a].name].length]
					if dataTypeVariable == galleryData[daysData[a].name][z].dataType
						#print "YES"
						index++
						columnIndex = index % columnCount
						rowIndex = Math.floor(index / columnCount)
						
						caard = new card
							x: (columnIndex * cardWidth)
							y: (rowIndex) * cardWidth
							parent: newDay.DayContent
							image: galleryData[daysData[a].name][z].thumb
						caard.identity.text = galleryData[daysData[a].name][z].dataType
						cards.push(caard)
			reSize(newDay)
			Xday += newDay.height
			index = -1



















