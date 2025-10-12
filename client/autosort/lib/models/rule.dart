
//typical flow of how data works in dart when connected to a backend 
//🟢 Backend → JSON → Map → Dart Object
//🔴 Dart Object → Map → JSON → Backend
//now note that json is literally just a string version of our map likt literally wvenwith the curly braces and all that it is just raw text 



class Rule {
  //this wholet thing specifically the rule class ie to convert a json into a usable dart object
  final String category;
  final List<String> extensions;

  Rule({required this.category, required this.extensions});

  //factory constructur to creata a rule instance from a json or a map
  factory Rule.fromMap(String category, List<String> extensions) { // So this is used like Rule.fromMap("documents", ["pdf", "docx", "txt"]);

    return Rule(
      category: category, //okay so this will look like category: "documents" but as an object property it will be category:"documents"
     extensions: extensions //same goes for this extensions:["pdf", "docx", "txt"]
     );
  }

  Map<String, dynamic> toMap() { //now to map converts our rule object back to a map in case we want to send it to the backend
    return {category: extensions}; //this will return a map like {"documents": ["pdf", "docx", "txt"]}
  }
}



