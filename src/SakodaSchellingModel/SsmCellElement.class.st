Class {
	#name : #SsmCellElement,
	#superclass : #BlElement,
	#instVars : [
		'cellPosition',
		'board',
		'position'
	],
	#category : #SakodaSchellingModel
}

{ #category : #accessing }
SsmCellElement >> board [
	^ board
]

{ #category : #accessing }
SsmCellElement >> board: anObject [
	board := anObject
]

{ #category : #accessing }
SsmCellElement >> cellPosition [
	^ cellPosition
]

{ #category : #accessing }
SsmCellElement >> cellPosition: aPoint [
	| cell |
	cellPosition := aPoint.
	cell := board cellAt: aPoint.
	self background: cell color.
	cell isEmpty
		ifFalse: [
			(board agentIsHappyAt: aPoint)
				ifFalse: [ self border: (BlBorder paint: Color red) ] ]
]

{ #category : #initializing }
SsmCellElement >> initialize [
	super initialize.
	self layout: BlFrameLayout new.
	self size: 20 @ 20.
	self geometry: (BlRoundedRectangleGeometry cornerRadius: 5).
]
