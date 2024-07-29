Extension { #name : #LzHomeSection }

{ #category : #'*SakodaSchellingModel' }
LzHomeSection >> sakodaSchellingModelCard [
	^ self
		newHeaderCardWithTitle: 'Sakoda-Schelling model'
		description: 'A Leibniz formalization of the Sakoda-Schelling model for racial segregation'
		size: 200@150
		content:
			(BrLabel new
				text: 'Sakoda-Schelling Model';
				aptitude: BrGlamorousLabelAptitude new
					bold;
				padding: (BlInsets all: 20)) asScalableElement
		action: [ :card | 
			| database startPage |
			database :=  BaselineOfSakodaSchellingModel lepiterDatabase.
			startPage := database
							pageNamed: 'The Sakoda-Schelling model for racial segregation'.
			GtWorldUtility 
				showSpaceWithTitle: startPage title
				inPagerWith: [ startPage
					asLepiterPagePhlowTool asElementDo: [ :e | e ] ] asStencil
				from: card ].
]
