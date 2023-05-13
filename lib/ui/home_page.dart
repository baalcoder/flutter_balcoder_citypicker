import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_balcoder_citypicker/utils/widget/country_picker/constants.dart';
import 'package:flutter_balcoder_citypicker/utils/widget/country_picker/helpers/create_options.dart';
import 'package:flutter_balcoder_citypicker/utils/widget/country_picker/multi_search_selection.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Country> _countries = [];
  List<Country> cities = [];

  TextEditingController _cSearch = new TextEditingController();
  late final dataJson;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readJson();
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/json/country.json');
    dataJson = await json.decode(response);
  }

  getCities(countryName) async {
    dataJson.forEach((country) {
      if (countryName == country['name']) {
        country['state'].forEach((state) {
          state['city'].forEach((city) {
            setState(() {
              cities
                  .add(Country(name: city['name'], iso: city['id'].toString()));
            });
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: _height,
        width: _width,
        child: Column(
          children: [
            Spacer(),
            Container(
              height: _height,
              width: _width,
              child: Row(
                children: [
                  Spacer(),
                  Container(
                    height: 400,
                    width: _width < 720 ? _width * 0.9 : _width * 0.3,
                    child: MultipleSearchSelection<Country>(
                      title: Text(
                        "Seleccionar países",
                        style: TextStyle(fontSize: 14),
                      ),
                      searchFieldTextEditingController: _cSearch,
                      hintText: 'Escriba aquí para buscar un país',
                      onItemAdded: (c) {
                        setState(() {
                          _countries.add(c);
                          _cSearch.text = '';
                        });
                        Future.delayed(Duration(milliseconds: 1), () {
                          getCities(c.name);
                        });
                      },
                      onItemRemoved: (c) {
                        setState(() {
                          cities = [];
                        });
                        // Future.delayed(Duration(milliseconds: 1), () {
                        //   getCities(c.name);
                        // });
                      },
                      showClearSearchFieldButton: true,
                      items: countries,
                      fieldToCheck: (c) {
                        return c.name;
                      },
                      itemBuilder: (country, index) {
                        return Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20.0,
                                horizontal: 12,
                              ),
                              child: Text(country.name),
                            ),
                          ),
                        );
                      },
                      onPickedChange: (p0) {},
                      pickedItemBuilder: (country) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey[400]!),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(country.name),
                          ),
                        );
                      },
                      sortShowedItems: true,
                      sortPickedItems: true,
                      onTapClearAll: () {
                        setState(() {
                          cities = [];
                        });
                      },
                      clearAllButton: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.red),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Borrar todo',
                              style: kStyleDefault.copyWith(fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                      caseSensitiveSearch: false,
                      fuzzySearch: FuzzySearch.none,
                      itemsVisibility: ShowedItemsVisibility.alwaysOn,
                      showSelectAllButton: true,
                      maximumShowItemsHeight: 200,
                    ),
                  ),
                  cities.isEmpty ? Container() : const SizedBox(width: 24),
                  cities.isEmpty
                      ? Container()
                      : Container(
                          height: 400,
                          width: _width < 720 ? _width * 0.9 : _width * 0.3,
                          child: MultipleSearchSelection<Country>.creatable(
                            title: Text(
                              "Seleccionar ciudades",
                              style: TextStyle(fontSize: 14),
                            ),
                            hintText: 'Escriba aquí para buscar una ciudad',

                            onItemAdded: (c) {},
                            showClearSearchFieldButton: true,
                            createOptions: OptionItems(
                              createItem: (text) {
                                return Country(name: text, iso: text);
                              },
                              createItemBuilder: (text) => Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Crear "$text"'),
                                ),
                              ),
                              pickCreatedItem: true,
                            ),
                            items: cities,
                            // List<Country>
                            fieldToCheck: (c) {
                              return c.name;
                            },
                            itemBuilder: (country, index) {
                              return Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20.0,
                                      horizontal: 12,
                                    ),
                                    child: Text(country.name),
                                  ),
                                ),
                              );
                            },
                            pickedItemBuilder: (country) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey[400]!),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(country.name),
                                ),
                              );
                            },
                            sortShowedItems: true,
                            sortPickedItems: true,
                            selectAllButton: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Seleccionar todo',
                                    style: kStyleDefault.copyWith(fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                            clearAllButton: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.red),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Borrar todo',
                                    style: kStyleDefault.copyWith(fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                            caseSensitiveSearch: false,
                            fuzzySearch: FuzzySearch.none,
                            itemsVisibility: ShowedItemsVisibility.alwaysOn,
                            showSelectAllButton: true,
                            maximumShowItemsHeight: 200,
                          ),
                        ),
                  Spacer(),
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
