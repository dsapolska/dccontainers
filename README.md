# dccontainers
Delphi containers library


Containers library written for Delphi 7.


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
