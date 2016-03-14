# Import file "sponsorised-ads-facebook"


#code sample by Sergiy Voronov  twitter.com/mamezito uxforblind.com

#special thanx to framer slack group,  Marc Krenn (huge thanx for pointing on pan functionality) and Jordan Dobson for their help


# facebook sketch file http://www.sketchappsources.com/free-source/881-facebook-post-ui-sketch-freebie-resource.html by Pedro Rebeiro

#reactions gifs by Seth Eckert https://dribbble.com/shots/2548560-Facebook-Reactions


Framer.Device.background.style.background = 
	"linear-gradient(45deg, #fff 30%, #caeaf7 100%)"

sketch = Framer.Importer.load("imported/sponsorised-ads-facebook@1x")

sketch.footer.states.add
	hidden:
		opacity:0
sketch.footerrelease.states.add
	hidden:
		opacity:0
sketch.likebutton.states.add
	hidden:
		opacity:0

sketch.footerrelease.states.switchInstant("hidden")


#creating white holder with shadow that will contain our reactions
reactionsHolder=new Layer
	width:430, height:75, backgroundColor: "white", borderRadius: 100,  y:1000, shadowY : 2, shadowBlur : 8, shadowColor : "rgba(0,0,0,0.2)", originY: 1, scaleY: 1.2, opacity:0

reactionsHolder.centerX()

#adding couple of states, so we will have 3 states- one hidden by default, initial state with all reactions same size, and smaller in height for state when one of the reactions is highlighted

reactionsHolder.states.add
		initial:
			scaleY: 1.2, opacity:0.9,y:970
		scaled:
			scaleY:1, opacity:0.9,y:970




#this bar will be just layer containing our reactions icons
reactionsBar=new Layer
	width:430, height:75, backgroundColor: "null", borderRadius: 100,  y:970,  originY: 1
reactionsBar.centerX()


#specifing array of labels
reactionLabels=["like","Love","Haha","Wow","Sad","Angry"]

#specifing array of url of images
reactionImages=["url('images/r1.gif')","url('images/r2.gif')","url('images/r3.gif')","url('images/r4.gif')","url('images/r5.gif')","url('images/r6.gif')"]
reactions = [] 

#specifying icon size, margin and number
Size=50
Margin=10
number=6



#here is the function that is creating array of the icons, adding labels to them and specifying different states for icons, like initial, equalsized shown state, large state and small state when some other icon is large
for index in [0...number]
	reaction = new Layer
		width: Size, height:Size
		superLayer: reactionsBar
		x: ((Size*1.13+Margin) * index)+Margin+11
		originY: 1
		y: 60
		opacity:0
		scale:0.5
		backgroundColor: "null"
	reaction.style="background":reactionImages[index],"background-size":"contain"
	reactionLabel=reaction.label=new Layer
		width:80, height:30, backgroundColor: "black", borderRadius: 50, superLayer: reaction, html:reactionLabels[index], scale:0.7,y:-30, opacity:0
	reactionLabel.style="text-align":"center","line-height":"30px", "font-size":"18px"
	reactionLabel.centerX()
	reactionLabel.states.add
		visible:
			opacity:1
	reaction.states.add
		initial:
			opacity:1
			x: ((Size*1.13+Margin) * index)+Margin+11
			y:10
			scale:1.15
		active:
			opacity:1
			scale:2
			y:10
			x:(60 * index)+10+Size/2
		beforeActive:
			opacity:1
			x:((Size+Margin) * index)+Margin
			scale:1
			y:10
		afterActive:
			opacity:1
			scale:1
			y:10
			x: ((Size+Margin) * index)+Margin+Size
		
	reactions.push reaction


#this function is doing the actual size change when we will be dragging our knob
reactionSwitch=(n)->
	if n>-1
		reactionsHolder.states.switch("scaled", time: 0.1, curve: "ease-out")
		for index in [0...n]
			reactions[index].states.switch("beforeActive",time: 0.1, curve: "ease-out")
			reactions[index].label.states.switch("default",time: 0.2, curve: "ease-out")
		for index in [n+1...number]
			reactions[index].states.switch("afterActive",time: 0.1, curve: "ease-out")
			reactions[index].label.states.switch("default",time: 0.2, curve: "ease-out")
		reactions[n].states.switch("active",time: 0.1, curve: "ease-in")
		reactions[n].label.states.switch("visible",time: 0.2, curve: "ease-in")
# 		reactionLabel.states.switch("visible",time: 0.1, curve: "ease-in")
		
	else
		reactionsHolder.states.switch("initial",time: 0.1, curve: "ease-out")
		for index in [0...number]
			reactions[index].states.switch("initial",time: 0.1, curve: "ease-out")
			reactions[index].label.states.switch("default",time: 0.2, curve: "ease-out")






# Round numbers to a set amount
round = (num, nearest) -> Math.round(num / nearest) * nearest





#layer to hold dots that are showing steps for our knob
dotsHolder=new Layer
	width:420, height:6, y:1130, backgroundColor: "null", opacity:0, x:140

dotsHolder.states.add
	visible:
		opacity:1
for i in [0...7]
		
		dots = new Layer 
			width: 6, height: 6, borderRadius: 10
			x: 25+(70 * i) - 3
			superLayer: dotsHolder
			backgroundColor: "rgba(0,0,0,0.2)"
		dots.centerY()


#clicking like button triggers showing reactions panel and the slider
sketch.likebutton.onTouchStart ->
	dotsHolder.states.switch("visible",time: 0.1, curve: "ease-in")
	sketch.footer.states.switchInstant("hidden")
	sketch.likebutton.states.switch("hidden",time: 0.1, curve: "ease-out")
	reactionsHolder.states.switch("initial",time: 0.1, curve: "ease-in")
	for index in [0...number]
		reactions[index].states.switch("initial",time: 0.1, delay:0.05*index,curve: 'spring(250,18,0)')

# #when we are paning like button to bottom, we are hiding dots and showing dissmiss message
sketch.likebutton.onPan (event) ->
	shiftX=round(event.offset.x, 35)/35
	if current!=(round(shiftX,1)-1)
		current=(round(shiftX,1)-1)
		if(current<6)
			reactionSwitch(round(shiftX,1)-1)
	if event.offset.y>30
		sketch.footerrelease.states.switchInstant("default")
		dotsHolder.states.switchInstant("default")
	else
		sketch.footerrelease.states.switchInstant("hidden")
		dotsHolder.states.switchInstant("visible")
		
# when pan on likebutton end and offset is big enough, we trigger dissmiss action and our page is going to initial state 
sketch.likebutton.onPanEnd (event)->
	if event.offset.y>30
		dotsHolder.states.switch("default",time: 0.1, curve: "ease-out")
		sketch.likebutton.states.switch("default",time: 0.1, curve: "ease-in")
		reactionsHolder.states.switch("default",time: 0.3, curve: "ease-out")
		sketch.footer.states.switchInstant("default")
		sketch.footerrelease.states.switchInstant("hidden")
		for index in [0...number]
			reverseIndex=number-index
			reactions[index].states.switch("default",time: 0.2, delay:0.05*reverseIndex, curve: 'spring(250,18,0)')
