#!/bin/sh

# INDEX
curl localhost:5000/guests

# SHOW
curl localhost:5000/guests/Deckard

# UPDATE
curl localhost:5000/guests/Deckard -d "custom_attributes[replicant]=definitely" -d "custom_attributes[lifespan]=4 years"

# HISTORY
curl localhost:5000/guests/history/Deckard
