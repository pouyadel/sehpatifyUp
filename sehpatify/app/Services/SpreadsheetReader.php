<?php

namespace App\Services;

use RuntimeException;
use ZipArchive;

class SpreadsheetReader
{
    /**
     * خواندن فایل .xlsx یا .csv و برگرداندن آرایه ردیف‌ها (هر ردیف: کلید => مقدار)
     */
    public static function parse(string $filePath, string $extension): array
    {
        $ext = strtolower($extension);
        $rawRows = ($ext === 'xlsx')
            ? self::readXlsx($filePath)
            : self::readCsv($filePath);

        if (count($rawRows) < 2) {
            return [];
        }

        $headers = array_map(function ($h) {
            $h = preg_replace('/^\xEF\xBB\xBF/', '', (string) $h);
            return mb_strtolower(trim($h), 'UTF-8');
        }, $rawRows[0]);

        $records = [];
        for ($i = 1; $i < count($rawRows); $i++) {
            $row = $rawRows[$i];
            $hasValue = false;
            foreach ($row as $cell) {
                if (trim((string) $cell) !== '') {
                    $hasValue = true;
                    break;
                }
            }
            if (!$hasValue) continue;

            $assoc = [];
            foreach ($headers as $colIdx => $key) {
                if ($key === '') continue;
                $assoc[$key] = isset($row[$colIdx]) ? trim((string) $row[$colIdx]) : '';
            }
            $records[] = $assoc;
        }

        return $records;
    }

    private static function readCsv(string $filePath): array
    {
        $content = file_get_contents($filePath);
        if ($content === false) {
            throw new RuntimeException('امکان خواندن فایل CSV وجود ندارد.');
        }

        // تشخیص خودکار جداکننده (کاما یا سمی‌کالن)
        $firstLine = strtok($content, "\r\n") ?: '';
        $delimiter = (substr_count($firstLine, ';') > substr_count($firstLine, ',')) ? ';' : ',';

        $rows = [];
        $handle = fopen($filePath, 'r');
        if (!$handle) return [];

        while (($data = fgetcsv($handle, 0, $delimiter)) !== false) {
            $rows[] = $data;
        }
        fclose($handle);

        return $rows;
    }

    private static function readXlsx(string $filePath): array
    {
        if (!class_exists(ZipArchive::class)) {
            throw new RuntimeException('افزونه PHP ZipArchive برای خواندن فایل xlsx فعال نیست؛ لطفاً فایل را با فرمت CSV UTF-8 ذخیره کنید.');
        }

        $zip = new ZipArchive();
        if ($zip->open($filePath) !== true) {
            throw new RuntimeException('فایل اکسل معتبر نیست یا آسیب دیده است.');
        }

        // ۱. خواندن رشته‌های مشترک (sharedStrings)
        $sharedStrings = [];
        $ssXml = $zip->getFromName('xl/sharedStrings.xml');
        if ($ssXml !== false) {
            $xml = @simplexml_load_string($ssXml);
            if ($xml) {
                foreach ($xml->si as $si) {
                    if (isset($si->t)) {
                        $sharedStrings[] = (string) $si->t;
                    } else {
                        $text = '';
                        foreach ($si->r as $run) {
                            $text .= (string) $run->t;
                        }
                        $sharedStrings[] = $text;
                    }
                }
            }
        }

        // ۲. خواندن شیت اول
        $sheetXml = $zip->getFromName('xl/worksheets/sheet1.xml');
        $zip->close();

        if ($sheetXml === false) {
            throw new RuntimeException('شیت اول داخل فایل اکسل یافت نشد.');
        }

        $sheet = @simplexml_load_string($sheetXml);
        if (!$sheet || !isset($sheet->sheetData->row)) {
            return [];
        }

        $rows = [];
        foreach ($sheet->sheetData->row as $rowNode) {
            $rowCells = [];
            $maxCol = 0;

            foreach ($rowNode->c as $cell) {
                $ref = (string) $cell['r']; // مثلاً C2
                $colLetters = preg_replace('/[0-9]+/', '', $ref);
                $colIdx = self::columnLettersToIndex($colLetters);
                if ($colIdx > $maxCol) $maxCol = $colIdx;

                $type = (string) $cell['t'];
                $val = '';
                if ($type === 's') {
                    $ssIdx = (int) $cell->v;
                    $val = $sharedStrings[$ssIdx] ?? '';
                } elseif ($type === 'inlineStr') {
                    $val = (string) ($cell->is->t ?? '');
                } else {
                    $val = (string) ($cell->v ?? '');
                }
                $rowCells[$colIdx] = $val;
            }

            $ordered = [];
            for ($c = 0; $c <= $maxCol; $c++) {
                $ordered[] = $rowCells[$c] ?? '';
            }
            $rows[] = $ordered;
        }

        return $rows;
    }

    private static function columnLettersToIndex(string $letters): int
    {
        $letters = strtoupper($letters);
        $index = 0;
        for ($i = 0; $i < strlen($letters); $i++) {
            $index = $index * 26 + (ord($letters[$i]) - ord('A') + 1);
        }
        return max(0, $index - 1);
    }

    /**
     * ساخت فایل نمونه واقعی .xlsx برای دانلود مستقیم از پنل ادمین
     */
    public static function createTemplateXlsx(): string
    {
        $rows = [
            ['title', 'artists', 'album', 'genre', 'search_keywords', 'is_lossless', 'cover_url', 'lyrics'],
            ['Bohemian Rhapsody (اختیاری - از فایل خوانده می‌شود)', 'Queen', 'A Night at the Opera', 'راک', 'کوئین، بوهمین راپسودی، Queen', '1', '', ''],
            ['', 'Sami Low, Arta', 'Azizam', 'رپ', 'عزیزم، سامی لو، آرتا، Azizam', '0', '', ''],
        ];

        $tmpFile = tempnam(sys_get_temp_dir(), 'sehpatify_tpl_') . '.xlsx';
        $zip = new ZipArchive();
        $zip->open($tmpFile, ZipArchive::CREATE | ZipArchive::OVERWRITE);

        $zip->addFromString('[Content_Types].xml', '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
            . '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
            . '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
            . '<Default Extension="xml" ContentType="application/xml"/>'
            . '<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>'
            . '<Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>'
            . '</Types>');

        $zip->addFromString('_rels/.rels', '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
            . '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
            . '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>'
            . '</Relationships>');

        $zip->addFromString('xl/workbook.xml', '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
            . '<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">'
            . '<sheets><sheet name="Tracks" sheetId="1" r:id="rId1"/></sheets>'
            . '</workbook>');

        $zip->addFromString('xl/_rels/workbook.xml.rels', '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
            . '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
            . '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>'
            . '</Relationships>');

        $sheetRowsXml = '';
        $colNames = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
        foreach ($rows as $rIdx => $row) {
            $rNum = $rIdx + 1;
            $sheetRowsXml .= "<row r=\"{$rNum}\">";
            foreach ($row as $cIdx => $val) {
                $ref = $colNames[$cIdx] . $rNum;
                $escaped = htmlspecialchars($val, ENT_XML1 | ENT_QUOTES, 'UTF-8');
                $sheetRowsXml .= "<c r=\"{$ref}\" t=\"inlineStr\"><is><t>{$escaped}</t></is></c>";
            }
            $sheetRowsXml .= '</row>';
        }

        $zip->addFromString('xl/worksheets/sheet1.xml', '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
            . '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">'
            . '<sheetData>' . $sheetRowsXml . '</sheetData>'
            . '</worksheet>');

        $zip->close();
        return $tmpFile;
    }
}