-- 選択したMIDIノートを次のノートの開始位置まで引き伸ばす
function stretch_notes_to_next()
    -- アクティブなMIDIエディタのテイクを取得
    local take = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())
    if not take then
        reaper.ShowMessageBox("MIDIエディタが開かれていません。", "エラー", 0)
        return
    end

    -- ノート情報を収集
    local notes = {}
    local note_idx = -1
    while true do
        note_idx = reaper.MIDI_EnumSelNotes(take, note_idx)
        if note_idx == -1 then break end
        local _, _, _, start_ppq, end_ppq, _, _, _ = reaper.MIDI_GetNote(take, note_idx)
        table.insert(notes, {index = note_idx, start = start_ppq, ["end"] = end_ppq})
    end

    -- ノートが少なくとも1つ必要
    if #notes < 1 then
        reaper.ShowMessageBox("選択されたノートがありません。", "エラー", 0)
        return
    end

    -- ノートを次のノートの開始位置まで伸ばす
    for i = 1, #notes - 1 do
        local current_note = notes[i]
        local next_note = notes[i + 1]
        reaper.MIDI_SetNote(
            take,
            current_note.index,
            nil, nil,
            current_note.start,
            next_note.start,  -- 次のノートの開始位置まで伸ばす
            nil, nil, nil, true
        )
    end

    -- MIDIデータをソートして変更を適用
    reaper.MIDI_Sort(take)
end

-- メイン処理の実行
reaper.Undo_BeginBlock()
stretch_notes_to_next()
reaper.Undo_EndBlock("Stretch selected notes to next note", -1)
