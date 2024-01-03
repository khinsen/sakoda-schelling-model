Extension { #name : #Point }

{ #category : #'*SakodaSchellingModel' }
Point >> manhattanDistanceTo: aPoint [
	| dx dy |
	dx := aPoint x - x.
	dy := aPoint y - y.
	^ dx abs + dy abs
]
