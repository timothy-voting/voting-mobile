import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:voting/requests.dart';
import '../size_config.dart';

class Rules extends StatefulWidget {
  const Rules({Key? key}) : super(key: key);

  @override
  State<Rules> createState() => _RulesState();
}

class _RulesState extends State<Rules> {
  bool agreed = false;
  bool refresh = true;
  late var rules = [];

  _getRules(){
    if(refresh) {
      Requests.getRules().then((rules) {
        if (rules is String) {
          setState(() {
            refresh = true;
          });
        }
        else if (rules is List<dynamic>) {
          var r = [];
          for (var rule in rules) {
            r.add(rule['statement'].toString());
          }

          setState(() {
            refresh = false;
            this.rules = r;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _getRules();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voting rules', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 26),),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal!),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.blockSizeVertical!),
            ...rules.map((rule) => Column(
              children: [
                Text('- $rule', style: const TextStyle(fontSize: 22)),
                SizedBox(height: SizeConfig.blockSizeVertical! * 2),
              ],
            )).toList(),
            (refresh)?
            Center(
              child: Column(
                children: [
                  IconButton(
                      onPressed: _getRules,
                      icon: const Icon(
                          Icons.replay,
                        color: Colors.green,
                        size: 40,
                      ),
                  ),
                  const Text('No connection!')
                ],
              ),
            ):
            Row(
              children: [
                Checkbox(
                  value: agreed,
                  onChanged: (bool? value) {
                    setState(() {
                      agreed = value!;
                    });
                  },
                ),
                const Text('I agree', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22))
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: FilledButton(
            onPressed: agreed?()=>Navigator.pushReplacementNamed(context, '/login'):null,
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(agreed?const Color(0xff008000):Colors.white),
            shape: const MaterialStatePropertyAll<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))))
          ),
            child: const Text('Proceed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white)),
          ),
      ),
    );
  }
}

