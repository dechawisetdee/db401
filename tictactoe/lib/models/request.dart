import 'package:flutter/material.dart';
class Requset extends StatelessWidget {
  final String gameId;
  final String challenger;
  final Function onAccept;

   const Requset({
   required this.gameId, 
   required this.challenger, 
   required this.onAccept,
   super.key
 });
  @override
  Widget build(BuildContext context) {
    return ListTile(
   title: Text(challenger),
   trailing: ElevatedButton(
     onPressed: () => onAccept(gameId), 
     child: const Text('Accept')
   ),
 );
  }
}