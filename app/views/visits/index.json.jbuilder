json.array!(@visits) do |visit|
  json.extract! visit, :id, :tipo, :inizio, :fine, :paziente, :descrizione
  json.url visit_url(visit, format: :json)
end
