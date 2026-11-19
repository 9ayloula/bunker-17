extends Node

signal item_added(item: String)

var items: Array[String] = []


func add_item(item: String) -> void:
	items.append(item)
	item_added.emit(item)
	print("Inventory: ", items)


func has_item(item: String) -> bool:
	return item in items
