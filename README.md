# dccontainers
Delphi containers library


This is containers library written for Delphi 7 as replacement for formerly used TStringList and DeCAL library.
We have here maps and sets, both with integer and string keys, where maps can store strings, integers and objects (descendants of TObject).


#### Library uses (and depends on):
* DUnit - to compile and execute automatic tests
* crc/hash library by Wolfgang Ehrhardt - for calculating BJL3 hashes
* RBTree by Freek van Walderveen, Jani Mátyás - for Red-Black tree implementation


#### Sample usage:

```delphi
	map : TDCMapString;
	dcptr : PDCTreeKeyValue;

	map:=TDCMapString.Create(TDCManagerList.Create, TDCHashBJL3.Create);
	map.Add('key1', 'example value');
	map.Add('key2', 12345);
	//...
	dcptr:=map.Find('key1');
	if dcptr <> nil then
		ShowMessage(dcptr^.Value.AsString);
```

More detailed usage can be found in _Tests_.
