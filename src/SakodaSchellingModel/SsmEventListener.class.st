Class {
	#name : #SsmEventListener,
	#superclass : #BlEventListener,
	#instVars : [
		'board',
		'cellPosition'
	],
	#category : #SakodaSchellingModel
}

{ #category : #accessing }
SsmEventListener >> board [
	^ board
]

{ #category : #accessing }
SsmEventListener >> board: anObject [
	board := anObject
]

{ #category : #accessing }
SsmEventListener >> cellPosition [
	^ cellPosition
]

{ #category : #accessing }
SsmEventListener >> cellPosition: anObject [
	cellPosition := anObject
]

{ #category : #accessing }
SsmEventListener >> clickEvent: anEvent [
	board ifNil: [ ^ self ].
	board spawnDebuggerForCellAt: cellPosition
]
