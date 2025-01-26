from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher


class ActionHelloWorld(Action):
    def name(self) -> Text:
        return "action_hello_world"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        # Получаем ID пользователя
        user_id = tracker.sender_id

        # Возвращаем сообщение с recipient_id
        print("tracker.sender_id", tracker.sender_id)
        dispatcher.utter_message(text="Hello World!", recipient_id=user_id)

        return []
