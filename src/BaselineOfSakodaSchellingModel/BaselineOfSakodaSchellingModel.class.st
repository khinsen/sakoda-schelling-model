Class {
	#name : #BaselineOfSakodaSchellingModel,
	#superclass : #BaselineOf,
	#category : #BaselineOfSakodaSchellingModel
}

{ #category : #loading }
BaselineOfSakodaSchellingModel class >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'sakoda-schelling-model' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : #baseline }
BaselineOfSakodaSchellingModel >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec
				baseline: 'LeibnizForGToolkit' 
				with: [ spec repository: 'github://khinsen/leibniz-pharo:master' ].
			spec
				package: 'SakodaSchellingModel'
				with: [ spec requires: #(LeibnizForGToolkit) ]
		]
]

{ #category : #loading }
BaselineOfSakodaSchellingModel >> postload: loader package: packageSpec [
	self class loadLepiter
]
