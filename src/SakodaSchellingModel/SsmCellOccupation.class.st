Class {
	#name : #SsmCellOccupation,
	#superclass : #Object,
	#category : #SakodaSchellingModel
}

{ #category : #accessing }
SsmCellOccupation >> = other [
	^ self class = other class
]

{ #category : #accessing }
SsmCellOccupation >> color [
	self subclassResponsibility
]

{ #category : #comparing }
SsmCellOccupation >> hash [
	^ self class hash
]

{ #category : #testing }
SsmCellOccupation >> isEmpty [
	self subclassResponsibility
]
