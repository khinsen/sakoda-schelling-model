Class {
	#name : #BaselineOfSakodaSchellingModel,
	#superclass : #BaselineOf,
	#category : #BaselineOfSakodaSchellingModel
}

{ #category : #accessing }
BaselineOfSakodaSchellingModel class >> databaseName [
	^ 'Sakoda-Schelling model'
]

{ #category : #accessing }
BaselineOfSakodaSchellingModel class >> lepiterDatabase [
	| logicalDB |
	logicalDB := LeDatabasesRegistry defaultLogicalDatabase.
	logicalDB
		databaseNamed: self databaseName
		ifNone: [ self loadLepiter ].
	^ logicalDB
		databaseNamed: self databaseName
]

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
			spec postLoadDoIt: #'postload:package:'.
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
	self class loadLepiter.
	GtWorld allInstances do: [ :aGtWorld |
		aGtWorld root children first home updateWidget ]
]
