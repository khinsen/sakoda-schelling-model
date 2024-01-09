Class {
	#name : #SsmHtmlExporter,
	#superclass : #LzHtmlExporter,
	#category : #SakodaSchellingModel
}

{ #category : #exporting }
SsmHtmlExporter class >> export [
	^ self new
		targetDirectoryName: 'sakoda-schelling-model';
		export
]

{ #category : #accessing }
SsmHtmlExporter >> initialize [
	super initialize.
	self database: (LeDatabasesRegistry defaultLogicalDatabase
						databaseNamed: 'Sakoda-Schelling model').
	self mainPage: 'The Sakoda-Schelling model for racial segregation'.
]
