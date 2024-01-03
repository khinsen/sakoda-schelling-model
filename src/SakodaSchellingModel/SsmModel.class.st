"
A straightforward Pharo implementation of the Sakoda-Schelling model
"
Class {
	#name : #SsmModel,
	#superclass : #Object,
	#instVars : [
		'board',
		'randomGenerator'
	],
	#category : #SakodaSchellingModel
}

{ #category : #'instance creation' }
SsmModel class >> fromRandomSeed: anInteger [
	^ self new
		randomGenerator: (Random new seed: anInteger);
		yourself
]

{ #category : #operating }
SsmModel >> agent: agentKind isHappyAt: aPosition [
	| neighbors sameKindNeighbors allNeighbors |
	self assert: agentKind isEmpty not.
	neighbors := self countNeighborsOf: agentKind at: aPosition.
	sameKindNeighbors := neighbors first.
	allNeighbors := neighbors second.
	^ sameKindNeighbors >= (allNeighbors / 2)
]

{ #category : #operating }
SsmModel >> agentIsHappyAt: aPoint [
	^ self
		agent: (self cellAt: aPoint)
		isHappyAt: aPoint
]

{ #category : #operating }
SsmModel >> allCellsDo: aBlock [
	1 to: self numberOfRows do: [ :aRow |
	 	1 to: self numberOfColumns do: [ :aColumn |
	 		aBlock value: aRow @ aColumn ] ]
]

{ #category : #operating }
SsmModel >> allCellsSelect: aBlock [
	| positions |
	positions := OrderedCollection new.
	self allCellsDo: [ :aPoint |
		(aBlock value: aPoint)
			ifTrue: [ positions add: aPoint ] ].
	^ positions
]

{ #category : #accessing }
SsmModel >> cellAt: aPosition [
	^ board at: aPosition x at: aPosition y
]

{ #category : #accessing }
SsmModel >> cellAt: aPosition put: aCellOccupation [
	board
		at: aPosition x at: aPosition y
		put: aCellOccupation
]

{ #category : #testing }
SsmModel >> cellIsEmptyAt: aPoint [
	^ (self cellAt: aPoint) isEmpty
]

{ #category : #operating }
SsmModel >> countNeighborsOf: agentKind at: aPosition [
	| allNeighbors sameKindNeighbors |
	allNeighbors := 0.
	sameKindNeighbors := 0.
	self neighborhoodOf: aPosition do: [ :nbPosition |
		(self cellIsEmptyAt: nbPosition)
			ifFalse: [
				allNeighbors := allNeighbors + 1.
				(agentKind = (self cellAt: nbPosition))
					ifTrue: [ sameKindNeighbors := sameKindNeighbors + 1 ] ] ].
	^ { sameKindNeighbors . allNeighbors }
]

{ #category : #operating }
SsmModel >> emptyCell [
	^ SsmEmptyCell new
]

{ #category : #operating }
SsmModel >> emptyCellPositionsSortedByDistanceFrom: aPosition [
	| distancesAndPositions |
	distancesAndPositions := self emptyCells collect: [ :eachPosition |
		{ eachPosition manhattanDistanceTo: aPosition . eachPosition } ].
	^ (distancesAndPositions
		sorted: [ :a :b | a first <= b first ])
		collect: #second
]

{ #category : #operating }
SsmModel >> emptyCells [
	^ self allCellsSelect: [ :aPosition |
		(self cellIsEmptyAt: aPosition)]
]

{ #category : #operating }
SsmModel >> emptyCellsSortedByDistanceFrom: aPosition [
	| distancesAndPositions |
	distancesAndPositions := self emptyCells collect: [ :eachPosition |
		{ eachPosition manhattanDistanceTo: aPosition . eachPosition } ].
	^ (distancesAndPositions
		sorted: [ :a :b | a first <= b first ])
		collect: #second
]

{ #category : #operating }
SsmModel >> fullPass [
	"Do a full pass over the board, attempting to move all unhappy
	 agents. Return true if any agent was moved, false otherwise."
	| moved |
	moved := false.
	self allCellsDo: [ :eachPoint |
		(self cellIsEmptyAt: eachPoint) ifFalse: [
			(self moveAgentAt: eachPoint)
				 ifTrue: [ moved := true ] ] ].
	^ moved
]

{ #category : #inspecting }
SsmModel >> gtBoardFor: aView [
	<gtView>
	^ aView explicit
		title: 'Board';
		priority: 1;
		stencil: [ SsmElement new board: self ];
		actionButtonIcon: BrGlamorousIcons fromhere 
			tooltip: 'One pass'
			action: [ :aButton :aTab |
				self fullPass.
				aTab viewContentElement children first update ];
		actionButtonIcon: BrGlamorousVectorIcons play 
			tooltip: 'Animation'
			action: [ :aButton :aTab |
				aTab viewContentElement children first multiplePassAnimation ];
		yourself
]

{ #category : #initializing }
SsmModel >> initialize [
	super initialize.
	randomGenerator := Random new
]

{ #category : #initializing }
SsmModel >> initializeBoardWithSize: aPoint fractionEmpty: aNumber [
	self assert: (aNumber between: 0 and: 1).
	board := Array2D rows: aPoint x columns: aPoint y.
	self allCellsDo: [ :eachPoint |
		self cellAt: eachPoint put:
			(randomGenerator next > aNumber
				ifFalse: [ SsmEmptyCell new]
				ifTrue: [
					randomGenerator next > 0.5
						ifTrue: [ SsmBlackCell new ]
						ifFalse: [ SsmWhiteCell new ] ] ) ]
]

{ #category : #testing }
SsmModel >> isValidPosition: aPoint [
	^ (aPoint x between: 1 and: self numberOfRows)
		and: [ aPoint y between: 1 and: self numberOfColumns ]
]

{ #category : #operating }
SsmModel >> moveAgentAt: aPoint [
	"Move the agent at aPoint if it is unhappy. Return true if
	 the agent was moved, false otherwise."
	| agent |
	agent := self cellAt: aPoint.
	(self agent: agent isHappyAt: aPoint)
		ifTrue: [ ^ false ].
	(self nearestEmptyCellProvidingHappinessTo: agent currentlyAt: aPoint)
		ifNil: [ ^ false ]
		ifNotNil: [ :happinessPoint |
			self cellAt: aPoint put: SsmEmptyCell new.
			self cellAt: happinessPoint put: agent.
			^ true ]
]

{ #category : #operating }
SsmModel >> multiplePassGenerator [
	^ Generator on: [ :g |
		[
			| moved |
			moved := false.
			self allCellsDo: [ :eachPoint |
				(self cellIsEmptyAt: eachPoint) ifFalse: [
					(self moveAgentAt: eachPoint)
						ifTrue: [
							moved := true.
							g yield: eachPoint ] ] ].
			moved ] whileTrue ]
]

{ #category : #operating }
SsmModel >> nearestEmptyCellProvidingHappinessTo: agent currentlyAt: aPoint [
	| nearest |
	"We must make the agent's current cell temporarily empty, because
	 it might be in the neighborhood of the candidate destinations."
	self cellAt: aPoint put: self emptyCell.
	nearest :=
		(self emptyCellPositionsSortedByDistanceFrom: aPoint)
			detect: [ :eachPoint |
				self agent: agent isHappyAt: eachPoint ]
			ifNone: [ nil ].
	self cellAt: aPoint put: agent.
	^ nearest
]

{ #category : #operating }
SsmModel >> neighborHoodOf: aPosition do: anObject [ 
]

{ #category : #operating }
SsmModel >> neighborhoodOf: aPosition do: aBlock [ 
	aPosition x - 1 to: aPosition x + 1 do: [ :nbRow |
		aPosition y - 1 to: aPosition y + 1 do: [ :nbColumn |
			| nbPosition |
			nbPosition := nbRow @ nbColumn.
			(nbPosition = aPosition)
				ifFalse: [
					(self isValidPosition: nbPosition)
						ifTrue: [ aBlock value:  nbPosition ] ] ] ]
]

{ #category : #accessing }
SsmModel >> numberOfColumns [
	^ board numberOfColumns
]

{ #category : #accessing }
SsmModel >> numberOfRows [
	^ board numberOfRows
]

{ #category : #accessing }
SsmModel >> randomGenerator: anObject [
	randomGenerator := anObject 
]

{ #category : #inspecting }
SsmModel >> spawnDebuggerForCellAt: aPoint [
	self halt.
	self moveAgentAt: aPoint
]
