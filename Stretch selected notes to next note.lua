import reaper_python as RPR

def stretch_notes_to_next_note():
    take = RPR.MIDIEditor_GetTake(RPR.MIDIEditor_GetActive())
    if not take:
        RPR.ShowMessageBox("MIDIエディタが開かれていません。", "エラー", 0)
        return
    
    # MIDIノート数を取得
    _, note_count, _, _ = RPR.MIDI_CountEvts(take)
    
    if note_count == 0:
        RPR.ShowMessageBox("選択されたMIDIノートがありません。", "エラー", 0)
        return

    # ノート情報を取得
    notes = []
    for i in range(note_count):
        _, selected, muted, start_ppq, end_ppq, chan, pitch, vel = RPR.MIDI_GetNote(take, i)
        if selected:
            notes.append((i, start_ppq, end_ppq, pitch))

    # ノートを次のノートの開始位置まで引き伸ばす
    for idx, note in enumerate(notes):
        note_idx, start_ppq, end_ppq, pitch = note
        
        # 次のノートが存在するか確認
        if idx + 1 < len(notes):
            next_note_start = notes[idx + 1][1]  # 次のノートの開始位置
            # ノートを更新
            RPR.MIDI_SetNote(take, note_idx, True, False, start_ppq, next_note_start, chan, pitch, vel, False)

    # 変更を適用
    RPR.MIDI_Sort(take)
    RPR.ShowMessageBox("ノートを次のノートまで引き伸ばしました。", "完了", 0)

# 実行
stretch_notes_to_next_note()
