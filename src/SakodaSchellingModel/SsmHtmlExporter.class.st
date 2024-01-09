Class {
	#name : #SsmHtmlExporter,
	#superclass : #LzHtmlExporter,
	#category : #SakodaSchellingModel
}

{ #category : #exporting }
SsmHtmlExporter class >> export [
	| database |
	database := LeDatabasesRegistry defaultLogicalDatabase
					databaseNamed: 'Sakoda-Schelling model'.
	^ self new
		database: database;
		targetDirectoryName: 'sakoda-schelling-model';
		mainPage: 'The Sakoda-Schelling model for racial segregation';
		export
]
