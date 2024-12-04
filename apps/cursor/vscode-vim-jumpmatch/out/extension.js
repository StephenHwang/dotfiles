"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.activate = activate;
const vscode = __importStar(require("vscode"));
const MATCH_PAIRS = {
    '(': ')',
    '[': ']',
    '{': '}',
    '<': '>'
};
function activate(context) {
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
        let nextPairPos = null;
        for (let line = position.line; line < document.lineCount; line++) {
            const lineText = document.lineAt(line).text;
            const startChar = line === position.line ? position.character : 0;
            for (let char = startChar; char < lineText.length; char++) {
                if (pairChars.includes(lineText[char])) {
                    nextPairPos = new vscode.Position(line, char);
                    break;
                }
            }
            if (nextPairPos)
                break;
        }
        // Find previous pair character (searching backward through document)
        let prevPairPos = null;
        for (let line = position.line; line >= 0; line--) {
            const lineText = document.lineAt(line).text;
            const startChar = line === position.line ? position.character : lineText.length - 1;
            for (let char = startChar; char >= 0; char--) {
                if (pairChars.includes(lineText[char])) {
                    prevPairPos = new vscode.Position(line, char);
                    break;
                }
            }
            if (prevPairPos)
                break;
        }
        console.log('Next pair pos:', nextPairPos, 'Prev pair pos:', prevPairPos);
        if (nextPairPos || prevPairPos) {
            // If we found a pair character, move to the closest one
            let targetPos;
            if (!nextPairPos) {
                targetPos = prevPairPos;
            }
            else if (!prevPairPos) {
                targetPos = nextPairPos;
            }
            else {
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
        }
        else {
            // If no pairs found, toggle between start and end of current line
            const line = editor.document.lineAt(position.line);
            const isAtStart = position.character === line.firstNonWhitespaceCharacterIndex;
            const newPosition = new vscode.Position(position.line, isAtStart ? line.text.length - 1 : line.firstNonWhitespaceCharacterIndex);
            editor.selection = new vscode.Selection(newPosition, newPosition);
            editor.revealRange(new vscode.Range(newPosition, newPosition));
        }
    });
    context.subscriptions.push(disposable);
}
//# sourceMappingURL=extension.js.map