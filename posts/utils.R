gt_custom <- function(data, head_max = 5, use_labels = TRUE) {
  
  data_subset <- as.data.frame(data) %>% head(head_max)
  
  gt_tbl <- data_subset %>%
    gt() %>%
    cols_align(align = "center", columns = everything()) %>%
    tab_style(
      style = cell_text(
        v_align = "middle",
        weight = "bold",
        whitespace = "normal"
      ),
      locations = cells_column_labels()
    ) %>%
    tab_options(
      row.striping.include_table_body = FALSE,
      table.background.color = "transparent",
      column_labels.background.color = "transparent",
      table.width = pct(100), 
      table.font.size = px(13),           
      data_row.padding = px(15), 
      column_labels.padding = px(15),
      table.border.top.style = "none",
      table.border.bottom.style = "none",
      table_body.hlines.style = "none", 
      column_labels.border.top.width = px(2),
      column_labels.border.top.color = "#757575",
      column_labels.border.bottom.width = px(2),
      column_labels.border.bottom.color = "#757575",
      table_body.border.bottom.width = px(2),
      table_body.border.bottom.color = "#757575"
    ) %>%
    opt_css(css = "
      .gt_table th, .gt_table td { 
        text-align: center !important; 
        vertical-align: middle !important;
      }
      .gt_table { 
        margin-left: auto !important; 
        margin-right: auto !important; 
        width: 100% !important;
      }
      .gt_table tr { background-color: transparent !important; }
      .gt_row { background-color: transparent !important; }
    ")
  
  # Apply labels only if requested
  if (use_labels) {
    gt_tbl <- gt_tbl %>%
      cols_label_with(
        fn = function(x) {
          html(paste0(
            "<b>", greek_labels[x], "</b>",
            "<br><span style='font-size:10px; color:#777; font-style:italic;'>",
            x,
            "</span>"
          ))
        }
      )
  }
  
  return(gt_tbl)
}