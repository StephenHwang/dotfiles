import * as vscode from 'vscode';

const MATCH_PAIRS: { [key: string]: string } = {
    '(': ')',
    '[': ']',
    '{': '}',
    '<': '>'
};

export function activate(context: vscode.ExtensionContext) {
    let disposable = vscode.commands.registerCommand('smartJump.jumpToMatch', async () => {
        console.log('Smart Jump activated');
        const editor = vscode.window.activeTextEditor;
        if (!editor) {
            console.log('No active editor');
            return;
        }

        const document = editor.document;
        const position = editor.selection.active;
        const pairChars = [...Object.keys(MATCH_PAIRS), ...Object.values(MATCH_PAIRS)];

        // Find next pair character (searching forward through document)
        let nextPairPos: vscode.Position | null = null;
        for (let line = position.line; line < document.lineCount; line++) {
            const lineText = document.lineAt(line).text;
            const startChar = line === position.line ? position.character : 0;
            
            for (let char = startChar; char < lineText.length; char++) {
                if (pairChars.includes(lineText[char])) {
                    nextPairPos = new vscode.Position(line, char);
                    break;
                }
            }
            if (nextPairPos) break;
        }

        // Find previous pair character (searching backward through document)
        let prevPairPos: vscode.Position | null = null;
        for (let line = position.line; line >= 0; line--) {
            const lineText = document.lineAt(line).text;
            const startChar = line === position.line ? position.character : lineText.length - 1;
            
            for (let char = startChar; char >= 0; char--) {
                if (pairChars.includes(lineText[char])) {
                    prevPairPos = new vscode.Position(line, char);
                    break;
                }
            }
            if (prevPairPos) break;
        }

        console.log('Next pair pos:', nextPairPos, 'Prev pair pos:', prevPairPos);

        if (nextPairPos || prevPairPos) {
            // If we found a pair character, move to the closest one
            let targetPos: vscode.Position;
            if (!nextPairPos) {
                targetPos = prevPairPos!;
            } else if (!prevPairPos) {
                targetPos = nextPairPos;
            } else {
                // Calculate distances (in characters) between positions
                const currentOffset = document.offsetAt(position);
                const nextOffset = document.offsetAt(nextPairPos);
                const prevOffset = document.offsetAt(prevPairPos);
                
                targetPos = (nextOffset - currentOffset) < (currentOffset - prevOffset)
                    ? nextPairPos
                    : prevPairPos;
            }

            // Move to the pair character
            editor.selection = new vscode.Selection(targetPos, targetPos);

            // Then jump to its match
            await vscode.commands.executeCommand('editor.action.jumpToBracket');
        } else {
            // If no pairs found, toggle between start and end of current line
            const line = editor.document.lineAt(position.line);
            const isAtStart = position.character === line.firstNonWhitespaceCharacterIndex;
            const newPosition = new vscode.Position(
                position.line,
                isAtStart ? line.text.length - 1 : line.firstNonWhitespaceCharacterIndex
            );
            
            editor.selection = new vscode.Selection(newPosition, newPosition);
            editor.revealRange(new vscode.Range(newPosition, newPosition));
        }
    });

    context.subscriptions.push(disposable);
}
