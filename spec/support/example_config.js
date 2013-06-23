addMock('datastoreConfig', {
		ReferenceEntityOne: [
			{ id:"1", propOne:"valueOne" },
			{ id:"2", propOne:"valueTwo" }
		],
		ReferenceEntityTwo: [
			{ id:"3", propOne:"valueOne", propTwo:"valueTwo" }
		],
		ParentEntity: [
			{ id:"4", propOne:"valueOne", referenceOne: { class: "ReferenceEntityOne", id: "1" }, referenceTwo: { class: "ReferenceEntityTwo", id: "3" } }
		],
		CollectionParentEntity: [
			{ id:"5", propOne:"valueOne", referenceOne: { class: "ReferenceEntityOne", id: "1" }, referenceTwo: { class: "ReferenceEntityTwo", id: "3" }, referenceCollection: { class: "ReferenceEntityOne", ids: [ "1", "2" ] } }
		]
	});