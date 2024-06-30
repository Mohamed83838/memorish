
import 'package:gemini/Models/GeminiResponse.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiPrompt {


final  String apiKey="AIzaSyCZqwfEcnA_nr5-nm0zJgL2yN1WVggGQ9o";

  Future<Response?> promptText(String description,bool title,String type) async {
    try {
      final model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: apiKey); // Specify the correct model ID

      final content = [Content.text("rules no comment no additional thought Generate a ${type} from this experience ${description} ${title?"generate a title as well put the title in the beginning and mark the end of it with a double * ":""  } ")];
      final response = await model.generateContent(content);



      final textResponse = response.text;
      if (textResponse == null || textResponse.isEmpty) {
        return null;
      }

      if(title){
        return Response(title: textResponse.substring(3,textResponse.indexOf("*")), description: textResponse.substring(textResponse.indexOf("*")+2));
      }else{
        return Response( title: '',description: textResponse);
      }
    } on Exception catch (e) {
      return null;
    }
  }
}
