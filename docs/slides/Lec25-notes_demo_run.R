library(httr2)
library(tidyverse)

url = "http://127.0.0.1:8080"

test_data = request(url) |>
  req_url_path_append("data", "test") |>
  req_perform() |>
  resp_body_json() |>
  bind_rows()

pred_data = test_data |>
  select(-species)

predictions = request(url) |>
  req_url_path_append("predict") |>
  req_body_json(pred_data) |>
  req_perform() |>
  resp_body_json() |>
  bind_rows()

predictions |>
  select(species = .pred_class, starts_with(".pred_")) |>
  bind_cols(actual = test_data$species) |>
  mutate(correct = species == actual)
