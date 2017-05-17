using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Assembler
{
    class Program
    {
        private static string Path =
            @"D:\3rd year-2nd term material\3- Computer architecture\4- Project\Project 2017\Assembler\";
        private const int MemoryLength = 1024;
        public static Dictionary<string, string> InstructionsOpCodes;
        public static Dictionary<string, string> OperandsCodes;

        static void Main(string[] args)
        {
            Init();
            var filelines = File.ReadAllLines("test.txt")
                                .Where(arg => !string.IsNullOrWhiteSpace(arg)).ToArray();
            var outList = AssembleFile(filelines);
            File.WriteAllLines("out.mem", outList);
            Console.WriteLine("File Assembled!");
            Console.ReadKey();
        }

        private static List<string> AssembleFile(string[] filelines)
        {
            var finalOutList = new List<string>();
            var startingAddress = int.Parse(filelines[0]);
            int j = 1;
            for (int i = 1; i <= MemoryLength; i++)
            {
                if (i < startingAddress)
                {
                    finalOutList.Add("0000000000000000");
                    continue;
                }

                if (j < filelines.Length)
                {
                    // Check if entered ISR area
                    int isrAddress;
                    if (int.TryParse(filelines[j], out isrAddress))
                    {
                        if (i < isrAddress)
                        {
                            for (int k = i; k < isrAddress; k++)
                            {
                                finalOutList.Add("0000000000000000");
                                i++;
                            }
                            j++;
                        }
                    }
                    
                    // Write instructions
                    var instBinary = FormInstructionBinary(filelines[j++]);
                    if (instBinary.Length == 32)
                    {
                        var word1 = instBinary.Substring(0, 16);
                        var word2 = instBinary.Substring(16, 16);
                        finalOutList.Add(word1);
                        i++;
                        finalOutList.Add(word2); //32-bit on 2 words
                    }
                    else if(instBinary.Length==16)
                    {
                        finalOutList.Add(instBinary); // 16-bit on 1 word
                    }
                    else
                    {
                        Console.WriteLine("FEH 7AGA 3'ALAT!!!!!"); //for debugging purposes!
                    }
                }
                else
                {
                    finalOutList.Add("0000000000000000");
                }
            }

            return finalOutList;
        }


        private static string FormInstructionBinary(string fileline)
        {
            string firstOperand, secondOperand, thirdOperand, instruction;
            string[] operandsList = { };

            #region Set Instruction & Operands

            // Handling all cases of input string format!
            var line = fileline.Trim();
            var leadingIndex = line.IndexOf(' ');
            var commentIndex = line.IndexOf('#');
            if (leadingIndex != -1)
            {
                instruction = line.Substring(0, leadingIndex).ToUpper();
                var operandsBag = commentIndex != -1 ?
                    line.Substring(leadingIndex + 1, commentIndex - leadingIndex - 1).ToUpper().Trim()
                    :
                    line.Substring(leadingIndex + 1).ToUpper().Trim();

                operandsList = operandsBag.Replace(" ", string.Empty).Split(',');
            }
            else
            {
                instruction = commentIndex!=-1 ? 
                    line.Substring(0, commentIndex).Replace("\t", string.Empty) 
                    : 
                    line.Replace("\t", string.Empty);
            }

            if (operandsList.Length != 0)
            {
                switch (operandsList.Length)
                {
                    case 1:
                        firstOperand = OperandsCodes[operandsList[0]];
                        secondOperand = thirdOperand = "";
                        break;
                    case 2:
                        firstOperand = OperandsCodes[operandsList[0]];
                        thirdOperand = "";
                        switch (instruction)
                        {
                            case "SHL":
                            case "SHR":
                                secondOperand = Convert.ToString(int.Parse(operandsList[1]), 2).PadLeft(4, '0');
                                break;
                            case "LDM":
                                secondOperand = Convert.ToString(int.Parse(operandsList[1]), 2).PadLeft(16, '0');
                                break;
                            case "LDD":
                            case "STD":
                                secondOperand = Convert.ToString(int.Parse(operandsList[1]), 2).PadLeft(10, '0');
                                break;
                            default:
                                secondOperand = OperandsCodes[operandsList[1]];
                                break;
                        }
                        break;
                    default:
                        firstOperand = OperandsCodes[operandsList[0]];
                        secondOperand = OperandsCodes[operandsList[1]];
                        thirdOperand = OperandsCodes[operandsList[2]];
                        break;
                }
            }
            else
            {
                firstOperand = secondOperand = thirdOperand = "";
            }
            #endregion

            var opCode = InstructionsOpCodes[instruction];
            var instructionBinary = "";
            switch (instruction)
            {
                #region No-operand instructions
                case "NOP":
                    instructionBinary = "0000000000000000";
                    break;
                case "RET":
                    instructionBinary = "1100100000011000";
                    break;
                case "RTI":
                    instructionBinary = "1101000000011000";
                    break;
                case "SETC":
                    instructionBinary = "0101000000000000";
                    break;
                case "CLRC":
                    instructionBinary = "0101100000000000";
                    break;
                #endregion

                #region One-operand instructions
                case "PUSH":
                    instructionBinary = opCode + "000" + firstOperand + "11000";
                    break;
                case "POP":
                    instructionBinary = opCode + firstOperand + "00011000";
                    break;
                case "OUT":
                    instructionBinary = opCode + "000" + firstOperand + "00000";
                    break;
                case "IN":
                    instructionBinary = opCode + firstOperand + "00000000";
                    break;
                case "NOT":
                case "NEG":
                case "INC":
                case "DEC":
                case "RLC":
                case "RRC":
                    instructionBinary = opCode + firstOperand + firstOperand + "00000";
                    break;
                case "JZ":
                case "JN":
                case "JC":
                case "JMP":
                    instructionBinary = opCode + "000" + firstOperand + "00000";
                    break;
                case "CALL":
                    instructionBinary = opCode + "000" + firstOperand + "11000";
                    break;
                #endregion

                #region 2-operand instructions
                case "MOV":
                    instructionBinary = opCode + firstOperand + secondOperand + "00000";
                    break;
                case "SHL":
                case "SHR":
                    instructionBinary = opCode + firstOperand + firstOperand + secondOperand + "0";
                    break;

                #endregion

                #region 3-operand instructions
                case "ADD":
                case "SUB":
                case "AND":
                case "OR":
                    instructionBinary = opCode + firstOperand + secondOperand + thirdOperand + "00";
                    break;
                #endregion

                #region Memory instructions
                case "STD":
                    instructionBinary = opCode + "000" + firstOperand + "00000000000" + secondOperand;
                    break;
                case "LDM":
                    instructionBinary = opCode + firstOperand + "00000000" + secondOperand;
                    break;
                case "LDD":
                    instructionBinary = opCode + firstOperand + "00000000000000" + secondOperand;
                    break;
                #endregion
            }
            return instructionBinary;
        }

        private static void Init()
        {
            InitOpCodeDictionary();
            InitOperandsCodeDictionary();
        }

        private static void InitOpCodeDictionary()
        {
            string[] instructions =
            {
                "NOP","MOV","RLC","RRC","ADD","SUB","AND","OR","SHL","SHR","SETC","CLRC",
                "PUSH","POP","OUT","IN","NOT","NEG","INC","DEC","JZ","JN","JC","JMP","CALL",
                "RET","RTI","LDM","LDD","STD"
            };
            InstructionsOpCodes = new Dictionary<string, string>();
            for (int i = 0; i < instructions.Length; i++)
            {
                InstructionsOpCodes.Add(instructions[i], Convert.ToString(i, 2).PadLeft(5, '0'));
            }
        }

        private static void InitOperandsCodeDictionary()
        {
            string[] operands = { "R0", "R1", "R2", "R3", "R4", "R5", "R6", "R7" };
            OperandsCodes = new Dictionary<string, string>();
            for (int i = 0; i < operands.Length; i++)
            {
                OperandsCodes.Add(operands[i], Convert.ToString(i, 2).PadLeft(3, '0'));
            }
            OperandsCodes.Add("SP", "110");
            OperandsCodes.Add("PC", "111");
        }




    }
}
