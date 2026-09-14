extends Node

enum Feature { LOGGING }

# If the feature is not in this dict, it will automatically be false
var features = {
	Feature.LOGGING: false,
}

func enabled(feature: Feature) -> bool:
	if features.has(feature):
		return features[feature]
	
	return false

# example
# Flipper.enabled(Flipper.Feature.LOGGING)
