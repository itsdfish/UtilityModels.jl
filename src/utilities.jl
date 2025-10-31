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
        column_labels = ["Value"],
        stubhead_label = "Parameter",
        compact_printing = false,
        row_label_column_alignment = :l,
        row_labels = [fieldnames(typeof(model))...],
        formatters = [fmt__printf("%5.2f", [2,])],
        alignment = :l
    )
end
