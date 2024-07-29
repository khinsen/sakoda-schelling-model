Extension { #name : #LzHomeSection }

{ #category : #'*SakodaSchellingModel' }
LzHomeSection >> sakodaSchellingCard [
	<gtSectionCard>
	^ GtHomeCard lepiterBaseWithTableOfContents
		title: 'Sakoda-Schelling model';
		description: 'A well-known model from sociology, rewritten in Leibniz.';
		pageName: 'The Sakoda-Schelling model for racial segregation';
		databaseName: BaselineOfSakodaSchellingModel
						lepiterDatabase
						properties databaseName;
		readMoreToolbar;
		details: [ :db | 
			| pages pagesWithDeclarations |
			pages := db pages.
			pagesWithDeclarations := pages select: [ :each |
				((each lzDBCache declarationCacheFor: each) declarationsFor: nil) isEmpty not ].
				'The book is expressed as a knowledge base. ',
				'It documents the Sakoda-Schelling model in ', pages size asString ,
				' pages, of which ',
				pagesWithDeclarations size asString,
				' contain context definitions.' ]
				yourself
]
