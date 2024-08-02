function Base.show(io::IO, ::MIME"text/plain", model::UtilityModel)
    return _show(io::IO, model)
end

function Base.show(io::IO, ::MIME"text/plain", model::Gamble)
    return _show(io::IO, model)
end

function _show(io::IO, model)
    values = [getfield(model, f) for f in fieldnames(typeof(model))]
    values = map(x -> typeof(x) == Bool ? string(x) : x, values)
    T = typeof(model)
    model_name = string(T.name.name)
    return pretty_table(
        io,
        values;
        title = model_name,
        row_label_column_title = "Parameter",
        compact_printing = false,
        header = ["Value"],
        row_label_alignment = :l,
        row_labels = [fieldnames(typeof(model))...],
        formatters = ft_printf("%5.2f"),
        alignment = :l
    )
end