Class {
	#name : #SsmEmptyCell,
	#superclass : #SsmCellOccupation,
	#category : #SakodaSchellingModel
}

{ #category : #accessing }
SsmEmptyCell >> color [
	^ Color gray
]

{ #category : #testing }
SsmEmptyCell >> isEmpty [
	^ true
]
